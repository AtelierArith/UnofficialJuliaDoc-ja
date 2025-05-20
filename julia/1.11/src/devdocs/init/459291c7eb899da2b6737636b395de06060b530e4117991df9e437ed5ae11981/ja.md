# Initialization of the Julia runtime

`julia -e 'println("Hello World!")'` の実行方法は以下の通りです。

## `main()`

実行は [`main()` in `cli/loader_exe.c`](https://github.com/JuliaLang/julia/blob/master/cli/loader_exe.c) で開始され、`jl_load_repl()` を呼び出します [`cli/loader_lib.c`](https://github.com/JuliaLang/julia/blob/master/cli/loader_lib.c) これはいくつかのライブラリを読み込み、最終的に [`jl_repl_entrypoint()` in `src/jlapi.c`](https://github.com/JuliaLang/julia/blob/master/src/jlapi.c) を呼び出します。

`jl_repl_entrypoint()` は [`libsupport_init()`](https://github.com/JuliaLang/julia/blob/master/src/support/libsupportinit.c) を呼び出して C ライブラリのロケールを設定し、「ios」ライブラリを初期化します（[`ios_init_stdstreams()`](https://github.com/JuliaLang/julia/blob/master/src/support/ios.c) と [Legacy `ios.c` library](@ref Legacy-ios.c-library))。

次 [`jl_parse_opts()`](https://github.com/JuliaLang/julia/blob/master/src/jloptions.c) はコマンドラインオプションを処理するために呼び出されます。 `jl_parse_opts()` は、コード生成や初期化に影響を与えるオプションのみを扱うことに注意してください。他のオプションは、後で [`exec_options()` in `base/client.jl`](https://github.com/JuliaLang/julia/blob/master/base/client.jl) によって後で処理されます。

`jl_parse_opts()` はコマンドラインオプションを [global `jl_options` struct](https://github.com/JuliaLang/julia/blob/master/src/julia.h) に保存します。

## `julia_init()`

[`julia_init()` in `init.c`](https://github.com/JuliaLang/julia/blob/master/src/init.c) は `main()` によって呼び出され、[`_julia_init()` in `init.c`](https://github.com/JuliaLang/julia/blob/master/src/init.c) を呼び出します。

`_julia_init()` は再度 `libsupport_init()` を呼び出します（2回目は何もしません）。

[`restore_signals()`](https://github.com/JuliaLang/julia/blob/master/src/signals-unix.c) は、シグナルハンドラーマスクをゼロにするために呼び出されます。

[`jl_resolve_sysimg_location()`](https://github.com/JuliaLang/julia/blob/master/src/init.c) は、基本システムイメージのために構成されたパスを検索します。 [Building the Julia system image](@ref Building-the-Julia-system-image) を参照してください。

[`jl_gc_init()`](https://github.com/JuliaLang/julia/blob/master/src/gc.c) は、弱参照、保持された値、およびファイナライゼーションのためのアロケーションプールとリストを設定します。

[`jl_init_frontend()`](https://github.com/JuliaLang/julia/blob/master/src/ast.c) は、スキャナー/パーサーを含む事前コンパイルされたfemtolispイメージをロードして初期化します。

[`jl_init_types()`](https://github.com/JuliaLang/julia/blob/master/src/jltypes.c) は `jl_datatype_t` 型の説明オブジェクトを [built-in types defined in `julia.h`](https://github.com/JuliaLang/julia/blob/master/src/julia.h) のために作成します。例えば、

```c
jl_any_type = jl_new_abstracttype(jl_symbol("Any"), core, NULL, jl_emptysvec);
jl_any_type->super = jl_any_type;

jl_type_type = jl_new_abstracttype(jl_symbol("Type"), core, jl_any_type, jl_emptysvec);

jl_int32_type = jl_new_primitivetype(jl_symbol("Int32"), core,
                                     jl_any_type, jl_emptysvec, 32);
```

[`jl_init_tasks()`](https://github.com/JuliaLang/julia/blob/master/src/task.c) は `jl_datatype_t* jl_task_type` オブジェクトを作成し、グローバル `jl_root_task` 構造体を初期化し、`jl_current_task` をルートタスクに設定します。

[`jl_init_codegen()`](https://github.com/JuliaLang/julia/blob/master/src/codegen.cpp) は [LLVM library](https://llvm.org) を初期化します。

[`jl_init_serializer()`](https://github.com/JuliaLang/julia/blob/master/src/staticdata.c) は、組み込みの `jl_value_t` 値のための 8 ビットシリアル化タグを初期化します。

もし sysimg ファイル (`!jl_options.image_file`) が存在しない場合、`Core` および `Main` モジュールが作成され、`boot.jl` が評価されます:

`jl_core_module = jl_new_module(jl_symbol("Core"))` は、Juliaの `Core` モジュールを作成します。

[`jl_init_intrinsic_functions()`](https://github.com/JuliaLang/julia/blob/master/src/intrinsics.cpp) は、新しいJuliaモジュール `Intrinsics` を作成し、定数 `jl_intrinsic_type` シンボルを含みます。これらは、各 [intrinsic function](https://github.com/JuliaLang/julia/blob/master/src/intrinsics.cpp) に対する整数コードを定義します。 [`emit_intrinsic()`](https://github.com/JuliaLang/julia/blob/master/src/intrinsics.cpp) は、コード生成中にこれらのシンボルをLLVM命令に変換します。

[`jl_init_primitives()`](https://github.com/JuliaLang/julia/blob/master/src/builtins.c) は、C関数をJulia関数シンボルにフックします。例えば、シンボル `Core.:(===)()` は、`add_builtin_func("===", jl_f_is)` を呼び出すことによってC関数ポインタ `jl_f_is()` にバインドされています。

[`jl_new_main_module()`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c) はグローバル "Main" モジュールを作成し、`jl_current_task->current_module = jl_main_module` を設定します。

注意: `_julia_init()` [then sets](https://github.com/JuliaLang/julia/blob/master/src/init.c) `jl_root_task->current_module = jl_core_module`。この時点で `jl_root_task` は `jl_current_task` のエイリアスであるため、上記の `jl_new_main_module()` によって設定された `current_module` は上書きされます。

[`jl_load("boot.jl", sizeof("boot.jl"))`](https://github.com/JuliaLang/julia/blob/master/src/init.c) は [`jl_parse_eval_all`](https://github.com/JuliaLang/julia/blob/master/src/ast.c) を呼び出し、これは繰り返し [`jl_toplevel_eval_flex()`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c) を呼び出して [`boot.jl`](https://github.com/JuliaLang/julia/blob/master/base/boot.jl) を実行します。 <!– TODO – evalを詳しく調べる？ –>

[`jl_get_builtin_hooks()`](https://github.com/JuliaLang/julia/blob/master/src/init.c) は、`boot.jl` で定義された Julia グローバルに対するグローバル C ポインタを初期化します。

[`jl_init_box_caches()`](https://github.com/JuliaLang/julia/blob/master/src/datatype.c) は、1024までの値のためにグローバルなボックス化された整数値オブジェクトを事前に割り当てます。これにより、後でボックス化された整数の割り当てが高速化されます。例えば:

```c
jl_value_t *jl_box_uint8(uint32_t x)
{
    return boxed_uint8_cache[(uint8_t)x];
}
```

[`_julia_init()` iterates](https://github.com/JuliaLang/julia/blob/master/src/init.c) は `jl_core_module->bindings.table` の上で `jl_datatype_t` 値を探し、型名のモジュールプレフィックスを `jl_core_module` に設定します。

[`jl_add_standard_imports(jl_main_module)`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c) does "using Base" in the "Main" module.

注意: `_julia_init()` は、上で `jl_core_module` に設定される前のように `jl_root_task->current_module = jl_main_module` に戻ります。

プラットフォーム固有のシグナルハンドラは、`SIGSEGV`（OSX、Linux）および `SIGFPE`（Windows）用に初期化されます。

他のシグナル（`SIGINFO, SIGBUS, SIGILL, SIGTERM, SIGABRT, SIGQUIT, SIGSYS` および `SIGPIPE`）は [`sigdie_handler()`](https://github.com/JuliaLang/julia/blob/master/src/signals-unix.c) に接続されており、バックトレースを出力します。

[`jl_init_restored_module()`](https://github.com/JuliaLang/julia/blob/master/src/staticdata.c)は、各デシリアライズされたモジュールに対して[`jl_module_run_initializer()`](https://github.com/JuliaLang/julia/blob/master/src/module.c)を呼び出し、`__init__()`関数を実行します。

最後に [`sigint_handler()`](https://github.com/JuliaLang/julia/blob/master/src/signals-unix.c) が `SIGINT` に接続され、`jl_throw(jl_interrupt_exception)` を呼び出します。

`_julia_init()` は [back to `main()` in `cli/loader_exe.c`](https://github.com/JuliaLang/julia/blob/master/cli/loader_exe.c) を返し、`main()` は `repl_entrypoint(argc, (char**)argv)` を呼び出します。

!!! sidebar "sysimg"
    もしsysimgファイルが存在する場合、それは`Core`および`Main`モジュールの事前に調理されたイメージ（および`boot.jl`によって作成されたその他のもの）を含んでいます。[Building the Julia system image](@ref Building-the-Julia-system-image)を参照してください。

    [`jl_restore_system_image()`](https://github.com/JuliaLang/julia/blob/master/src/staticdata.c) は、保存された sysimg を現在の Julia ランタイム環境にデシリアライズし、`jl_init_box_caches()` の下で初期化が続行されます...

    注意: [`jl_restore_system_image()` (and `staticdata.c` in general)](https://github.com/JuliaLang/julia/blob/master/src/staticdata.c) は [Legacy `ios.c` library](@ref Legacy-ios.c-library) を使用しています。


## `repl_entrypoint()`

[`repl_entrypoint()`](https://github.com/JuliaLang/julia/blob/master/src/jlapi.c) は `argv[]` の内容を [`Base.ARGS`](@ref) にロードします。

もしコマンドラインに`.jl`の「プログラム」ファイルが供給された場合、[`exec_program()`](https://github.com/JuliaLang/julia/blob/master/src/jlapi.c)は[`jl_load(program,len)`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c)を呼び出し、これは[`jl_parse_eval_all`](https://github.com/JuliaLang/julia/blob/master/src/ast.c)を呼び出し、これは繰り返し[`jl_toplevel_eval_flex()`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c)を呼び出してプログラムを実行します。

However, in our example (`julia -e 'println("Hello World!")'`), [`jl_get_global(jl_base_module, jl_symbol("_start"))`](https://github.com/JuliaLang/julia/blob/master/src/module.c) looks up [`Base._start`](https://github.com/JuliaLang/julia/blob/master/base/client.jl) and [`jl_apply()`](https://github.com/JuliaLang/julia/blob/master/src/julia.h) executes it.

## `Base._start`

[`Base._start`](https://github.com/JuliaLang/julia/blob/master/base/client.jl) は [`Base.exec_options`](https://github.com/JuliaLang/julia/blob/master/base/client.jl) を呼び出し、さらに [`jl_parse_input_line("println("Hello World!")")`](https://github.com/JuliaLang/julia/blob/master/src/ast.c) を呼び出して式オブジェクトを作成し、[`Core.eval(Main, ex)`](@ref Core.eval) を呼び出して `Main` のモジュールコンテキストで解析された式 `ex` を実行します。

## `Core.eval`

[`Core.eval(Main, ex)`](@ref Core.eval) は [`jl_toplevel_eval_in(m, ex)`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c) を呼び出し、さらに [`jl_toplevel_eval_flex`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c) を呼び出します。 `jl_toplevel_eval_flex` は、与えられたコードスンクをコンパイルするか、インタプリタで実行するかを決定するための単純なヒューリスティックを実装しています。 `println("Hello World!")` が与えられた場合、通常はインタプリタでコードを実行することを決定し、その場合は [`jl_interpret_toplevel_thunk`](https://github.com/JuliaLang/julia/blob/master/src/interpreter.c) を呼び出し、次に [`eval_body`](https://github.com/JuliaLang/julia/blob/master/src/interpreter.c) を呼び出します。

スタックダンプは、インタープリタが [`Base.println()`](@ref) と [`Base.print()`](@ref) のさまざまなメソッドを通過して、最終的に [`write(s::IO, a::Array{T}) where T`](https://github.com/JuliaLang/julia/blob/master/base/stream.jl) に到達する様子を示しています。これは `ccall(jl_uv_write())` を実行します。

[`jl_uv_write()`](https://github.com/JuliaLang/julia/blob/master/src/jl_uv.c)は、`JL_STDOUT`に「Hello World!」を書き込むために`uv_write()`を呼び出します。[Libuv wrappers for stdio](@ref Libuv-wrappers-for-stdio)を参照してください。

```
Hello World!
```

| Stack frame                   | Source code     | Notes                                                |
|:----------------------------- |:--------------- |:---------------------------------------------------- |
| `jl_uv_write()`               | `jl_uv.c`       | called though [`ccall`](@ref)                        |
| `julia_write_282942`          | `stream.jl`     | function `write!(s::IO, a::Array{T}) where T`        |
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

私たちの例には関数呼び出しが1つだけあり、それが「Hello World!」を印刷する仕事を終えたので、スタックはすぐに`main()`に戻ります。

## `jl_atexit_hook()`

`main()` は [`jl_atexit_hook()`](https://github.com/JuliaLang/julia/blob/master/src/init.c) を呼び出します。これにより `Base._atexit` が呼び出され、その後 [`jl_gc_run_all_finalizers()`](https://github.com/JuliaLang/julia/blob/master/src/gc.c) が呼び出され、libuv ハンドルがクリーンアップされます。

## `julia_save()`

最後に、`main()`は[`julia_save()`](https://github.com/JuliaLang/julia/blob/master/src/init.c)を呼び出します。これはコマンドラインで要求されると、ランタイム状態を新しいシステムイメージに保存します。[`jl_compile_all()`](https://github.com/JuliaLang/julia/blob/master/src/gf.c)および[`jl_save_system_image()`](https://github.com/JuliaLang/julia/blob/master/src/staticdata.c)を参照してください。
