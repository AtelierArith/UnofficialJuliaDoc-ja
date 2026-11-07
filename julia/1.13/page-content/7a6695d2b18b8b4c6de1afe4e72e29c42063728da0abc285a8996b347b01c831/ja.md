# [gdb debugging tips](@id gdb-debugging-tips)

## Displaying Julia variables

`gdb` 内では、任意の `jl_value_t*` オブジェクト `obj` を、次のように表示できます。

```
(gdb) call jl_(obj)
```

オブジェクトは gdb セッションではなく、`julia` セッションに表示されます。これは、Julia の C コードが操作しているオブジェクトの型や値を調べるのに便利な方法です。

同様に、Julia の内部の一部（例: `compiler.jl`）をデバッグしている場合は、次のようにして `obj` を出力できます。

```julia
ccall(:jl_, Cvoid, (Any,), obj)
```

これは、Julia の出力ストリームが初期化される順序に起因する問題を回避するのに有効です。

Julia の flisp インタープリターは `value_t` オブジェクトを使用します。これらは `call fl_print(fl_ctx, ios_stdout, obj)` で表示できます。

## Useful Julia variables for Inspecting

シングルトンなど、多くの変数のアドレスを出力すると、さまざまな障害の調査に役立ちます。しかし、さらに有用な変数もいくつかあります（一覧は `julia.h` を参照）。

  * （`jl_apply_generic` の場合）`mfunc` と `jl_uncompress_ast(mfunc->def, mfunc->code)` :: コールスタックの概要を把握するのに役立ちます
  * `jl_lineno` と `jl_filename` :: テストのどの行からデバッグを始めるべきか（またはファイルのどこまで解析されたか）を調べるのに役立ちます
  * `$1` :: 厳密には変数ではありませんが、直前の gdb コマンドの結果（たとえば `print`）を参照する便利な略記です
  * `jl_options` :: 正常に解析されたコマンドラインオプションがすべて一覧表示されるため、ときに役立ちます
  * `jl_uv_stderr` :: stdio とやり取りできるのは便利です

## Useful Julia functions for Inspecting those variables

  * `jl_print_task_backtraces(0)` :: gdb の `thread apply all bt` や lldb の `thread backtrace all` に似ています。すべてのスレッドを実行しながら、存在するすべてのタスクのバックトレースを出力します。
  * `jl_gdblookup($pc)` :: 現在の関数と行を調べます。
  * `jl_gdblookupinfo($pc)` :: 現在のメソッドインスタンスオブジェクトを調べます。
  * `jl_gdbdumpcode(mi)` :: REPL が正常に動作しない場合に、`code_typed/code_llvm/code_asm` の全内容をダンプします。
  * `jlbacktrace()` :: 現在の Julia のバックトレーススタックを stderr にダンプします。`record_backtrace()` の呼び出し後にのみ使用できます。
  * `jl_dump_llvm_value(Value*)` :: gdb ではネイティブに動作しない `Value->dump()` を gdb 内で呼び出します。例: `f->linfo->functionObject`、`f->linfo->specFunctionObject`、`to_function(f->linfo)`。
  * `jl_dump_llvm_module(Module*)` :: gdb ではネイティブに動作しない `Module->dump()` を gdb 内で呼び出します。
  * `Type->dump()` :: lldb でのみ動作します。注: lldb のプロンプトが出力に重ならないよう、`;1` のようなものを追加してください。
  * `jl_eval_string("expr")` :: 現在の状態を変更する副作用を起こしたり、シンボルを検索したりするために使います。
  * `jl_typeof(jl_value_t*)` :: Julia の値の型タグを取り出します（gdb では、まず `macro define jl_typeof jl_typeof` を呼び出すか、最初の引数に `ty` のような短い名前を選んで略記を定義してください）。

## Inserting breakpoints for inspection from gdb

`gdb` セッションで、次のように `jl_breakpoint` にブレークポイントを設定します。

```
(gdb) break jl_breakpoint
```

次に、Julia コード内に `jl_breakpoint` の呼び出しを挿入します。そのためには、次を追加します。

```julia
ccall(:jl_breakpoint, Cvoid, (Any,), obj)
```

ここで `obj` には、ブレークポイントで参照したい任意の変数またはタプルを指定できます。

特に、`jl_apply` フレームまでスタックを戻すと便利です。そこでは、たとえば次のようにして関数の引数を表示できます。

```
(gdb) call jl_(args[0])
```

もう一つ便利なフレームは `to_function(jl_method_instance_t *li, bool cstyle)` です。`jl_method_instance_t*` 引数は、コンパイラーに渡された最終 AST への参照を持つ構造体です。ただし、この時点の AST は通常圧縮されています。AST を表示するには、`jl_uncompress_ast` を呼び出し、その結果を `jl_` に渡します。

```
#2  0x00007ffff7928bf7 in to_function (li=0x2812060, cstyle=false) at codegen.cpp:584
584          abort();
(gdb) p jl_(jl_uncompress_ast(li, li->ast))
```

## Inserting breakpoints upon certain conditions

### Loading a particular file

ファイル名が `sysimg.jl` だとします。

```
(gdb) break jl_load if strcmp(fname, "sysimg.jl")==0
```

### Calling a particular method

```
(gdb) break jl_apply_generic if strcmp((char*)(jl_symbol_name)(jl_gf_mtable(F)->name), "method_to_break")==0
```

この関数は呼び出しのたびに使われるため、これを行うと処理が 1000 倍遅くなります。

## Dealing with signals

Julia が正常に動作するには、いくつかのシグナルが必要です。プロファイラーはサンプリングに `SIGUSR2` を使用し、ガベージコレクターはスレッド同期に `SIGSEGV` を使用します。プロファイラーや複数スレッドを使うコードをデバッグしている場合、通常の動作中に頻繁に発生するこれらのシグナルを、デバッガーが無視するよう設定するとよいでしょう。GDB では次のコマンドを使います（`SIGSEGV` は、無視したい `SIGUSR2` またはその他のシグナルに置き換えてください）。

```
(gdb) handle SIGSEGV noprint nostop pass
```

対応する LLDB のコマンドは次のとおりです（プロセスの起動後に実行します）。

```
(lldb) pro hand -p true -s false -n false SIGSEGV
```

スレッドを使うコードでセグメンテーション違反をデバッグしている場合は、`jl_fprint_critical_error` にブレークポイントを設定できます（Linux と BSD では `sigdie_handler` も使えます）。これにより、GC の同期ポイントではなく、実際のセグメンテーション違反だけを捕捉できます。

## Debugging during Julia's build process (bootstrap)

`make` 中に発生するエラーには、特別な対応が必要です。Julia は 2 段階でビルドされ、`sys0` と `sys.ji` が構築されます。失敗時に実行されているコマンドを確認するには、`make VERBOSE=1` を使います。

執筆時点では、`sys0` フェーズのビルドエラーは、`base` ディレクトリから次のようにしてデバッグできます。

```
julia/base$ gdb --args ../usr/bin/julia-debug -C native --build ../usr/lib/julia/sys0 sysimg.jl
```

これを機能させるには、`usr/lib/julia/` 内のファイルをすべて削除する必要があるかもしれません。

`sys.ji` フェーズは、次のようにしてデバッグできます。

```
julia/base$ gdb --args ../usr/bin/julia-debug -C native --build ../usr/lib/julia/sys -J ../usr/lib/julia/sys0.ji sysimg.jl
```

デフォルトでは、gdb の実行中であっても、エラーが発生すると Julia は終了します。エラーが発生した瞬間を捕捉するには、`jl_error` にブレークポイントを設定します（特定の種類の障害に使える場所はほかにもあり、`jl_too_few_args`、`jl_too_many_args`、`jl_throw` などがあります）。

エラーを捕捉したら、スタックを上にたどり、関連する `jl_apply` の呼び出しを調べて関数を確認する方法が有効です。実例を示します。

```
Breakpoint 1, jl_throw (e=0x7ffdf42de400) at task.c:802
802 {
(gdb) p jl_(e)
ErrorException("auto_unbox: unable to determine argument type")
$2 = void
(gdb) bt 10
#0  jl_throw (e=0x7ffdf42de400) at task.c:802
#1  0x00007ffff65412fe in jl_error (str=0x7ffde56be000 <_j_str267> "auto_unbox:
   unable to determine argument type")
   at builtins.c:39
#2  0x00007ffde56bd01a in julia_convert_16886 ()
#3  0x00007ffff6541154 in jl_apply (f=0x7ffdf367f630, args=0x7fffffffc2b0, nargs=2) at julia.h:1281
...
```

最も新しい `jl_apply` はフレーム #3 にあるため、そこに戻って関数 `julia_convert_16886` の AST を確認できます。これは、`convert` のあるメソッドに付けられた一意な名前です。このフレームの `f` は `jl_value_t*` なので、`specTypes` フィールドから型シグネチャがあれば確認できます。

```
(gdb) f 3
#3  0x00007ffff6541154 in jl_apply (f=0x7ffdf367f630, args=0x7fffffffc2b0, nargs=2) at julia.h:1281
1281            return f->fptr((jl_value_t*)f, args, nargs);
(gdb) p f->linfo->specTypes
$4 = (jl_tupletype_t *) 0x7ffdf39b1030
(gdb) p jl_( f->linfo->specTypes )
Tuple{Type{Float32}, Float64}           # <-- type signature for julia_convert_16886
```

次に、この関数の AST を確認します。

```
(gdb) p jl_( jl_uncompress_ast(f->linfo, f->linfo->ast) )
Expr(:lambda, Array{Any, 1}[:#s29, :x], Array{Any, 1}[Array{Any, 1}[], Array{Any, 1}[Array{Any, 1}[:#s29, :Any, 0], Array{Any, 1}[:x, :Any, 0]], Array{Any, 1}[], 0], Expr(:body,
Expr(:line, 90, :float.jl)::Any,
Expr(:return, Expr(:call, :box, :Float32, Expr(:call, :fptrunc, :Float32, :x)::Any)::Any)::Any)::Any)::Any
```

最後に、おそらく最も有用な方法として、関数を再コンパイルさせ、コード生成の過程をステップ実行できます。そのためには、`jl_lambda_info_t*` からキャッシュ済みの `functionObject` を消去します。

```
(gdb) p f->linfo->functionObject
$8 = (void *) 0x1289d070
(gdb) set f->linfo->functionObject = NULL
```

次に、適切な場所（例: `emit_function`、`emit_expr`、`emit_call` など）にブレークポイントを設定し、コード生成を実行します。

```
(gdb) p jl_compile(f)
... # your breakpoint here
```

## Debugging precompilation errors

モジュールのプリコンパイルでは、モジュールごとに別の Julia プロセスが起動されます。プリコンパイルワーカーでブレークポイントを設定したり、失敗を捕捉したりするには、そのワーカーにデバッガーをアタッチする必要があります。最も簡単なのは、指定した名前に一致する新しいプロセスの起動をデバッガーで監視する方法です。たとえば、次のようにします。

```
(gdb) attach -w -n julia-debug
```

または:

```
(lldb) process attach -w -n julia-debug
```

その後、プリコンパイルを開始するスクリプトまたはコマンドを実行します。前述のとおり、親プロセスで条件付きブレークポイントを使って特定のファイル読み込みイベントを捕捉し、デバッグ対象の範囲を絞り込みます。（OS によっては、親プロセスから各 `fork` を追跡するなど、別の方法が必要になる場合があります。）

## Mozilla's Record and Replay Framework (rr)

Julia は現在、Mozilla の軽量な記録・決定論的デバッグフレームワークである [rr](https://rr-project.org/) に標準で対応しています。これにより、実行のトレースを決定論的に再生できます。再生された実行では、アドレス空間、レジスターの内容、システムコールのデータなどが、毎回まったく同じになります。

rr はバージョン 3.1.0 以降が必要です。

### Reproducing concurrency bugs with rr

デフォルトでは、rr は単一スレッドのマシンをシミュレートします。並行コードをデバッグするには、`rr record --chaos` を使うと、rr が 1～8 個のコアをランダムに選んでシミュレートします。そのため、バグを捕捉できるまで `JULIA_NUM_THREADS=8` を設定し、rr の下でコードを繰り返し実行するとよいでしょう。
