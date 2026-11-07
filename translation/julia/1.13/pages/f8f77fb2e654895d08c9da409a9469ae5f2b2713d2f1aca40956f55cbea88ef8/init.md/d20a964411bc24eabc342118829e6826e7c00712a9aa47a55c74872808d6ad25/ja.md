# Initialization of the Julia runtime

Juliaランタイムは `julia -e 'println("Hello World!")'` をどのように実行するのでしょうか？

## `main()`

実行は [`main()` in `cli/loader_exe.c`](https://github.com/JuliaLang/julia/blob/master/cli/loader_exe.c) から始まります。ここから [`cli/loader_lib.c`](https://github.com/JuliaLang/julia/blob/master/cli/loader_lib.c) 内の `jl_load_repl()` が呼び出され、いくつかのライブラリが読み込まれた後、最終的に [`jl_repl_entrypoint()` in `src/jlapi.c`](https://github.com/JuliaLang/julia/blob/master/src/jlapi.c) が呼び出されます。

`jl_repl_entrypoint()` は [`libsupport_init()`](https://github.com/JuliaLang/julia/blob/master/src/support/libsupportinit.c) を呼び出し、Cライブラリのロケールを設定して「ios」ライブラリを初期化します（[`ios_init_stdstreams()`](https://github.com/JuliaLang/julia/blob/master/src/support/ios.c) および [Legacy `ios.c` library](@ref Legacy-ios.c-library) を参照）。

次に、コマンドラインオプションを処理するため、[`jl_parse_opts()`](https://github.com/JuliaLang/julia/blob/master/src/jloptions.c) が呼び出されます。`jl_parse_opts()` が扱うのは、コード生成や初期段階の初期化に影響するオプションだけであることに注意してください。それ以外のオプションは、後で [`exec_options()` in `base/client.jl`](https://github.com/JuliaLang/julia/blob/master/base/client.jl) によって処理されます。

`jl_parse_opts()` は、コマンドラインオプションを [global `jl_options` struct](https://github.com/JuliaLang/julia/blob/master/src/julia.h) に格納します。

## `julia_init()`

`main()` から [`julia_init()` in `init.c`](https://github.com/JuliaLang/julia/blob/master/src/init.c) が呼び出され、さらに [`_julia_init()` in `init.c`](https://github.com/JuliaLang/julia/blob/master/src/init.c) が呼び出されます。

`_julia_init()` は、まず `libsupport_init()` を再度呼び出します（2回目の呼び出しでは何もしません）。

シグナルハンドラーのマスクをゼロにするため、[`restore_signals()`](https://github.com/JuliaLang/julia/blob/master/src/signals-unix.c) が呼び出されます。

[`jl_resolve_sysimg_location()`](https://github.com/JuliaLang/julia/blob/master/src/init.c) は、設定されたパスからベースシステムイメージを探します。[Building the Julia system image](@ref Building-the-Julia-system-image) を参照してください。

[`jl_gc_init()`](https://github.com/JuliaLang/julia/blob/master/src/gc.c) は、割り当てプールと、弱参照、保持された値、ファイナライズを管理するためのリストを設定します。

[`jl_init_frontend()`](https://github.com/JuliaLang/julia/blob/master/src/ast.c) は、スキャナーとパーサーを含むプリコンパイル済みのfemtolispイメージを読み込み、初期化します。

[`jl_init_types()`](https://github.com/JuliaLang/julia/blob/master/src/jltypes.c) は、[built-in types defined in `julia.h`](https://github.com/JuliaLang/julia/blob/master/src/julia.h) 用の `jl_datatype_t` 型記述オブジェクトを作成します。例：

```c
jl_any_type = jl_new_abstracttype(jl_symbol("Any"), core, NULL, jl_emptysvec);
jl_any_type->super = jl_any_type;

jl_type_type = jl_new_abstracttype(jl_symbol("Type"), core, jl_any_type, jl_emptysvec);

jl_int32_type = jl_new_primitivetype(jl_symbol("Int32"), core,
                                     jl_any_type, jl_emptysvec, 32);
```

[`jl_init_tasks()`](https://github.com/JuliaLang/julia/blob/master/src/task.c) は、`jl_datatype_t* jl_task_type` オブジェクトを作成し、グローバルな `jl_root_task` 構造体を初期化して、`jl_current_task` をルートタスクに設定します。

[`jl_init_codegen()`](https://github.com/JuliaLang/julia/blob/master/src/codegen.cpp) は [LLVM library](https://llvm.org) を初期化します。

[`jl_init_serializer()`](https://github.com/JuliaLang/julia/blob/master/src/staticdata.c) は、組み込みの `jl_value_t` 値に対する8ビットのシリアライズタグを初期化します。

sysimgファイルがない場合（`!jl_options.image_file`）、`Core` モジュールと `Main` モジュールが作成され、`boot.jl` が評価されます。

`jl_core_module = jl_new_module(jl_symbol("Core"), NULL)` は、Juliaの `Core` モジュールを作成します。

[`jl_init_intrinsic_functions()`](https://github.com/JuliaLang/julia/blob/master/src/intrinsics.cpp) は、定数である `jl_intrinsic_type` シンボルを含む新しいJuliaモジュール `Intrinsics` を作成します。これらのシンボルは、各 [intrinsic function](https://github.com/JuliaLang/julia/blob/master/src/intrinsics.cpp) に対する整数コードを定義します。[`emit_intrinsic()`](https://github.com/JuliaLang/julia/blob/master/src/intrinsics.cpp) は、コード生成時にこれらのシンボルをLLVM命令に変換します。

[`jl_init_primitives()`](https://github.com/JuliaLang/julia/blob/master/src/builtins.c) は、C関数をJuliaの関数シンボルに結び付けます。たとえば、`add_builtin_func("===", jl_f_is)` を呼び出すことで、シンボル `Core.:(===)()` がC関数ポインター `jl_f_is()` に束縛されます。

[`jl_new_main_module()`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c) は、グローバルな「Main」モジュールを作成し、`jl_current_task->current_module = jl_main_module` を設定します。

注：`_julia_init()` [then sets](https://github.com/JuliaLang/julia/blob/master/src/init.c) `jl_root_task->current_module = jl_core_module`。この時点では `jl_root_task` は `jl_current_task` の別名なので、上記の `jl_new_main_module()` によって設定された `current_module` は上書きされます。

[`jl_load("boot.jl", sizeof("boot.jl"))`](https://github.com/JuliaLang/julia/blob/master/src/init.c) は [`jl_parse_eval_all`](https://github.com/JuliaLang/julia/blob/master/src/ast.c) を呼び出します。これは [`jl_toplevel_eval_flex()`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c) を繰り返し呼び出して、[`boot.jl`](https://github.com/JuliaLang/julia/blob/master/base/boot.jl) を実行します。<!– TODO – evalの詳細に踏み込む？ –>

[`jl_get_builtin_hooks()`](https://github.com/JuliaLang/julia/blob/master/src/init.c) は、`boot.jl` で定義されたJuliaのグローバル変数を指す、グローバルなCポインターを初期化します。

[`jl_init_box_caches()`](https://github.com/JuliaLang/julia/blob/master/src/datatype.c) は、1024までの値について、ボックス化された整数値のグローバルオブジェクトを事前に割り当てます。これにより、以降のボックス化整数の割り当てが高速化されます。例：

```c
jl_value_t *jl_box_uint8(uint32_t x)
{
    return boxed_uint8_cache[(uint8_t)x];
}
```

[`_julia_init()` iterates](https://github.com/JuliaLang/julia/blob/master/src/init.c) は `jl_core_module->bindings.table` を走査して `jl_datatype_t` 値を探し、型名のモジュール接頭辞を `jl_core_module` に設定します。

[`jl_add_standard_imports(jl_main_module)`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c) は、「Main」モジュールで「using Base」を実行します。

注：ここで `_julia_init()` は、上記で `jl_core_module` に設定される前の `jl_root_task->current_module = jl_main_module` に戻ります。

`SIGSEGV`（OSX、Linux）および `SIGFPE`（Windows）に対して、プラットフォーム固有のシグナルハンドラーが初期化されます。

その他のシグナル（`SIGINFO, SIGBUS, SIGILL, SIGTERM, SIGABRT, SIGQUIT, SIGSYS` および `SIGPIPE`）は、バックトレースを出力する [`sigdie_handler()`](https://github.com/JuliaLang/julia/blob/master/src/signals-unix.c) に結び付けられます。

[`jl_init_restored_module()`](https://github.com/JuliaLang/julia/blob/master/src/staticdata.c) は、デシリアライズされた各モジュールに対して [`jl_module_run_initializer()`](https://github.com/JuliaLang/julia/blob/master/src/module.c) を呼び出し、`__init__()` 関数を実行します。

最後に、[`sigint_handler()`](https://github.com/JuliaLang/julia/blob/master/src/signals-unix.c) が `SIGINT` に結び付けられ、`jl_throw(jl_interrupt_exception)` を呼び出します。

その後、`_julia_init()` は [back to `main()` in `cli/loader_exe.c`](https://github.com/JuliaLang/julia/blob/master/cli/loader_exe.c) に戻り、`main()` が `repl_entrypoint(argc, (char**)argv)` を呼び出します。

!!! sidebar "sysimg"
    sysimgファイルがある場合、その中には `Core` モジュールと `Main` モジュール（および `boot.jl` によって作成されるその他すべて）の構築済みイメージが含まれています。[Building the Julia system image](@ref Building-the-Julia-system-image) を参照してください。

    [`jl_restore_system_image()`](https://github.com/JuliaLang/julia/blob/master/src/staticdata.c) は、保存されたsysimgを現在のJuliaランタイム環境にデシリアライズし、初期化は以下の `jl_init_box_caches()` の後から続行されます…

    注：[`jl_restore_system_image()` (and `staticdata.c` in general)](https://github.com/JuliaLang/julia/blob/master/src/staticdata.c) は [Legacy `ios.c` library](@ref Legacy-ios.c-library) を使用します。


## `repl_entrypoint()`

[`repl_entrypoint()`](https://github.com/JuliaLang/julia/blob/master/src/jlapi.c) は、`argv[]` の内容を [`Base.ARGS`](@ref) に読み込みます。

コマンドラインで `.jl` の「プログラム」ファイルが指定されていた場合、[`exec_program()`](https://github.com/JuliaLang/julia/blob/master/src/jlapi.c) が [`jl_load(program,len)`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c) を呼び出し、そこから [`jl_parse_eval_all`](https://github.com/JuliaLang/julia/blob/master/src/ast.c) が呼び出されます。これは [`jl_toplevel_eval_flex()`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c) を繰り返し呼び出してプログラムを実行します。

ただし、今回の例（`julia -e 'println("Hello World!")'`）では、[`jl_get_global(jl_base_module, jl_symbol("_start"))`](https://github.com/JuliaLang/julia/blob/master/src/module.c) が [`Base._start`](https://github.com/JuliaLang/julia/blob/master/base/client.jl) を検索し、[`jl_apply()`](https://github.com/JuliaLang/julia/blob/master/src/julia.h) がそれを実行します。

## `Base._start`

[`Base._start`](https://github.com/JuliaLang/julia/blob/master/base/client.jl) は [`Base.exec_options`](https://github.com/JuliaLang/julia/blob/master/base/client.jl) を呼び出します。これは [`jl_parse_input_line("println("Hello World!")")`](https://github.com/JuliaLang/julia/blob/master/src/ast.c) を呼び出して式オブジェクトを作成し、[`Core.eval(Main, ex)`](@ref Core.eval) を呼び出して、解析済みの式 `ex` を `Main` のモジュールコンテキストで実行します。

## `Core.eval`

[`Core.eval(Main, ex)`](@ref Core.eval) は [`jl_toplevel_eval_in(m, ex)`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c) を呼び出し、さらに [`jl_toplevel_eval_flex`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c) が呼び出されます。`jl_toplevel_eval_flex` は、与えられたコードのサンクをコンパイルするか、インタープリターで実行するかを判断する単純なヒューリスティックを実装しています。`println("Hello World!")` が与えられた場合、通常はインタープリターで実行すると判断します。その場合、[`jl_interpret_toplevel_thunk`](https://github.com/JuliaLang/julia/blob/master/src/interpreter.c) が呼び出され、そこから [`eval_body`](https://github.com/JuliaLang/julia/blob/master/src/interpreter.c) が呼び出されます。

以下のスタックダンプは、インタープリターが [`Base.println()`](@ref) と [`Base.print()`](@ref) のさまざまなメソッドをたどり、`ccall(jl_uv_write())` を実行する [`write(s::IO, a::Array{T}) where T`](https://github.com/JuliaLang/julia/blob/master/base/stream.jl) に到達するまでの様子を示しています。

[`jl_uv_write()`](https://github.com/JuliaLang/julia/blob/master/src/jl_uv.c) は `uv_write()` を呼び出して、「Hello World!」を `JL_STDOUT` に書き込みます。[Libuv wrappers for stdio](@ref Libuv-wrappers-for-stdio) を参照してください。

```
Hello World!
```

| スタックフレーム                      | ソースコード          | 備考                                                   |
|:----------------------------- |:--------------- |:---------------------------------------------------- |
| `jl_uv_write()`               | `jl_uv.c`       | [`ccall`](@ref) 経由で呼び出される                            |
| `julia_write_282942`          | `stream.jl`     | 関数 `write!(s::IO, a::Array{T}) where T`              |
| `julia_print_284639`          | `ascii.jl`      | `print(io::IO, s::String) = (write(io, s); nothing)` |
| `jlcall_print_284639`         |                 |                                                      |
| `jl_apply()`                  | `julia.h`       |                                                      |
| `jl_trampoline()`             | `builtins.c`    |                                                      |
| `jl_apply()`                  | `julia.h`       |                                                      |
| `jl_apply_generic()`          | `gf.c`          | `Base.print(Base.TTY, String)`                       |
| `jl_apply()`                  | `julia.h`       |                                                      |
| `jl_trampoline()`             | `builtins.c`    |                                                      |
| `jl_apply()`                  | `julia.h`       |                                                      |
| `jl_apply_generic()`          | `gf.c`          | `Base.print(Base.TTY, String, Char, Char...)`        |
| `jl_apply()`                  | `julia.h`       |                                                      |
| `jl_f_apply()`                | `builtins.c`    |                                                      |
| `jl_apply()`                  | `julia.h`       |                                                      |
| `jl_trampoline()`             | `builtins.c`    |                                                      |
| `jl_apply()`                  | `julia.h`       |                                                      |
| `jl_apply_generic()`          | `gf.c`          | `Base.println(Base.TTY, String, String...)`          |
| `jl_apply()`                  | `julia.h`       |                                                      |
| `jl_trampoline()`             | `builtins.c`    |                                                      |
| `jl_apply()`                  | `julia.h`       |                                                      |
| `jl_apply_generic()`          | `gf.c`          | `Base.println(String,)`                              |
| `jl_apply()`                  | `julia.h`       |                                                      |
| `do_call()`                   | `interpreter.c` |                                                      |
| `eval_body()`                 | `interpreter.c` |                                                      |
| `jl_interpret_toplevel_thunk` | `interpreter.c` |                                                      |
| `jl_toplevel_eval_flex`       | `toplevel.c`    |                                                      |
| `jl_toplevel_eval_in`         | `toplevel.c`    |                                                      |
| `Core.eval`                   | `boot.jl`       |                                                      |

今回の例には関数呼び出しが1つしかなく、「Hello World!」を出力するという役割を終えたため、スタックはここから速やかに巻き戻され、`main()` に戻ります。

## `jl_atexit_hook()`

`main()` は [`jl_atexit_hook()`](https://github.com/JuliaLang/julia/blob/master/src/init.c) を呼び出します。これは `Base._atexit` を呼び出した後、[`jl_gc_run_all_finalizers()`](https://github.com/JuliaLang/julia/blob/master/src/gc.c) を呼び出し、libuvハンドルをクリーンアップします。

## `julia_save()`

最後に、`main()` が [`julia_save()`](https://github.com/JuliaLang/julia/blob/master/src/init.c) を呼び出します。これは、コマンドラインで指定されていれば、ランタイムの状態を新しいシステムイメージに保存します。[`jl_compile_all()`](https://github.com/JuliaLang/julia/blob/master/src/gf.c) および [`jl_save_system_image()`](https://github.com/JuliaLang/julia/blob/master/src/staticdata.c) を参照してください。
