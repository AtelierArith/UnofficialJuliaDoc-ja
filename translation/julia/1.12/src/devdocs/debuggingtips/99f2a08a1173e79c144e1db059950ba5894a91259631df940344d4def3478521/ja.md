# [gdb debugging tips](@id gdb-debugging-tips)

## Displaying Julia variables

`gdb`内で、任意の`jl_value_t*`オブジェクト`obj`は次のように表示できます。

```
(gdb) call jl_(obj)
```

オブジェクトは `julia` セッションに表示され、gdb セッションには表示されません。これは、Julia の C コードによって操作されているオブジェクトの型と値を発見するための便利な方法です。

同様に、Juliaの内部（例：`compiler.jl`）をデバッグしている場合は、次のようにして`obj`を印刷できます。

```julia
ccall(:jl_, Cvoid, (Any,), obj)
```

これは、Juliaの出力ストリームが初期化される順序から生じる問題を回避する良い方法です。

Juliaのflispインタープリタは`value_t`オブジェクトを使用します。これらは`call fl_print(fl_ctx, ios_stdout, obj)`で表示できます。

## Useful Julia variables for Inspecting

多くの変数、例えばシングルトンのアドレスは、多くの失敗に対して印刷するのに役立ちますが、さらに便利な追加の変数がいくつかあります（完全なリストについては `julia.h` を参照してください）。

  * (when in `jl_apply_generic`) `mfunc` と `jl_uncompress_ast(mfunc->def, mfunc->code)` :: コールスタックについて少し理解するためのもの
  * `jl_lineno` と `jl_filename` :: テストのどの行からデバッグを開始するか（またはファイルがどれだけ解析されたか）を把握するためのものです。
  * `$1` :: 実際には変数ではありませんが、最後のgdbコマンド（例えば`print`）の結果を参照するための便利な省略形です。
  * `jl_options` :: 時々便利で、成功裏に解析されたすべてのコマンドラインオプションをリストします。
  * `jl_uv_stderr` :: なぜなら、誰もがstdioと対話できることを好むからです

## Useful Julia functions for Inspecting those variables

  * `jl_print_task_backtraces(0)` :: gdbの`thread apply all bt`やlldbの`thread backtrace all`に似ています。すべてのスレッドを実行し、すべての既存のタスクのバックトレースを印刷します。
  * `jl_gdblookup($pc)` :: 現在の関数と行を調べるためのものです。
  * `jl_gdblookupinfo($pc)` :: 現在のメソッドインスタンスオブジェクトを検索するためのものです。
  * `jl_gdbdumpcode(mi)` :: REPLが正しく動作していないときに、すべての`code_typed/code_llvm/code_asm`をダンプするためのものです。
  * `jlbacktrace()` :: 現在のJuliaバックトレーススタックをstderrにダンプするためのものです。`record_backtrace()`が呼び出された後のみ使用可能です。
  * `jl_dump_llvm_value(Value*)` :: gdbで`Value->dump()`を呼び出すためのもので、ネイティブでは動作しません。例えば、`f->linfo->functionObject`、`f->linfo->specFunctionObject`、および`to_function(f->linfo)`です。
  * `jl_dump_llvm_module(Module*)` :: gdbで`Module->dump()`を呼び出すためのもので、ネイティブでは動作しません。
  * `Type->dump()` :: lldb でのみ動作します。注意: lldb が出力の上にプロンプトを表示しないように `;1` のようなものを追加してください。
  * `jl_eval_string("expr")` :: 現在の状態を変更したり、シンボルを検索したりするために副作用を呼び出すためのものです。
  * `jl_typeof(jl_value_t*)` :: Juliaの値の型タグを抽出するためのもの（gdbでは、最初に`macro define jl_typeof jl_typeof`を呼び出すか、短いものを選んで最初の引数に`ty`のようなショートハンドを定義します）

## Inserting breakpoints for inspection from gdb

`gdb` セッションで、次のように `jl_breakpoint` にブレークポイントを設定します:

```
(gdb) break jl_breakpoint
```

その後、あなたのJuliaコード内に`jl_breakpoint`を呼び出すコードを追加します。

```julia
ccall(:jl_breakpoint, Cvoid, (Any,), obj)
```

`obj` は、ブレークポイントでアクセス可能にしたい任意の変数またはタプルです。

`jl_apply` フレームにバックアップすることは特に役立ちます。そこから、例えば、関数に対する引数を表示することができます。

```
(gdb) call jl_(args[0])
```

別の便利なフレームは `to_function(jl_method_instance_t *li, bool cstyle)` です。`jl_method_instance_t*` 引数は、コンパイラに送信される最終的なASTへの参照を持つ構造体です。しかし、この時点でのASTは通常圧縮されています。ASTを表示するには、`jl_uncompress_ast` を呼び出し、その結果を `jl_` に渡します：

```
#2  0x00007ffff7928bf7 in to_function (li=0x2812060, cstyle=false) at codegen.cpp:584
584          abort();
(gdb) p jl_(jl_uncompress_ast(li, li->ast))
```

## Inserting breakpoints upon certain conditions

### Loading a particular file

ファイル名は `sysimg.jl` としましょう：

```
(gdb) break jl_load if strcmp(fname, "sysimg.jl")==0
```

### Calling a particular method

```
(gdb) break jl_apply_generic if strcmp((char*)(jl_symbol_name)(jl_gf_mtable(F)->name), "method_to_break")==0
```

この関数はすべての呼び出しに使用されるため、これを行うとすべてが1000倍遅くなります。

## Dealing with signals

Juliaは正常に機能するためにいくつかのシグナルを必要とします。プロファイラはサンプリングのために`SIGUSR2`を使用し、ガーベジコレクタはスレッドの同期のために`SIGSEGV`を使用します。プロファイラや複数のスレッドを使用しているコードをデバッグしている場合、通常の操作中にこれらのシグナルが非常に頻繁にトリガーされる可能性があるため、デバッガにこれらのシグナルを無視させたいかもしれません。GDBでこれを行うためのコマンドは次のとおりです（`SIGSEGV`を無視したい他のシグナルに置き換えてください）：

```
(gdb) handle SIGSEGV noprint nostop pass
```

対応するLLDBコマンドは（プロセスが開始された後）:

```
(lldb) pro hand -p true -s false -n false SIGSEGV
```

スレッドコードでセグメンテーションフォルトをデバッグしている場合、実際のセグメンテーションフォルトをキャッチするために、`jl_critical_error`（LinuxおよびBSDでは`sigdie_handler`も機能します）にブレークポイントを設定できます。

## Debugging during Julia's build process (bootstrap)

`make`中に発生するエラーは特別な処理が必要です。Juliaは2段階で構築され、`sys0`と`sys.ji`が作成されます。失敗時に実行されているコマンドを確認するには、`make VERBOSE=1`を使用してください。

この文を書いている時点では、`base` ディレクトリから `sys0` フェーズ中のビルドエラーをデバッグすることができます。次のコマンドを使用してください:

```
julia/base$ gdb --args ../usr/bin/julia-debug -C native --build ../usr/lib/julia/sys0 sysimg.jl
```

`usr/lib/julia/`内のすべてのファイルを削除する必要があるかもしれません。これを機能させるために。

`sys.ji` フェーズをデバッグするには、次のようにします:

```
julia/base$ gdb --args ../usr/bin/julia-debug -C native --build ../usr/lib/julia/sys -J ../usr/lib/julia/sys0.ji sysimg.jl
```

デフォルトでは、エラーが発生すると、Juliaは終了します。gdbの下でも同様です。エラーを「その瞬間に」キャッチするには、`jl_error`にブレークポイントを設定します（特定の種類の失敗に対して、`jl_too_few_args`、`jl_too_many_args`、`jl_throw`など、他にもいくつかの便利な場所があります）。

エラーがキャッチされると、役立つテクニックはスタックを遡り、`jl_apply`への関連する呼び出しを検査することで関数を調べることです。実際の例を挙げると：

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

最も最近の `jl_apply` はフレーム #3 にあるので、そこに戻って関数 `julia_convert_16886` の AST を見てみましょう。これは `convert` のいくつかのメソッドのユニークな名前です。このフレームの `f` は `jl_function_t*` なので、`specTypes` フィールドから型シグネチャを確認できます。

```
(gdb) f 3
#3  0x00007ffff6541154 in jl_apply (f=0x7ffdf367f630, args=0x7fffffffc2b0, nargs=2) at julia.h:1281
1281            return f->fptr((jl_value_t*)f, args, nargs);
(gdb) p f->linfo->specTypes
$4 = (jl_tupletype_t *) 0x7ffdf39b1030
(gdb) p jl_( f->linfo->specTypes )
Tuple{Type{Float32}, Float64}           # <-- type signature for julia_convert_16886
```

次に、この関数のASTを見てみましょう：

```
(gdb) p jl_( jl_uncompress_ast(f->linfo, f->linfo->ast) )
Expr(:lambda, Array{Any, 1}[:#s29, :x], Array{Any, 1}[Array{Any, 1}[], Array{Any, 1}[Array{Any, 1}[:#s29, :Any, 0], Array{Any, 1}[:x, :Any, 0]], Array{Any, 1}[], 0], Expr(:body,
Expr(:line, 90, :float.jl)::Any,
Expr(:return, Expr(:call, :box, :Float32, Expr(:call, :fptrunc, :Float32, :x)::Any)::Any)::Any)::Any)::Any
```

最後に、そしておそらく最も便利なことに、関数を再コンパイルさせてコード生成プロセスをステップ実行することができます。これを行うには、`jl_lamdbda_info_t*`からキャッシュされた`functionObject`をクリアします:

```
(gdb) p f->linfo->functionObject
$8 = (void *) 0x1289d070
(gdb) set f->linfo->functionObject = NULL
```

その後、どこか便利な場所（例：`emit_function`、`emit_expr`、`emit_call`など）にブレークポイントを設定し、コード生成を実行します：

```
(gdb) p jl_compile(f)
... # your breakpoint here
```

## Debugging precompilation errors

モジュールの事前コンパイルは、各モジュールを事前コンパイルするために別のJuliaプロセスを生成します。事前コンパイルワーカーでブレークポイントを設定したり、失敗をキャッチしたりするには、ワーカーにデバッガをアタッチする必要があります。最も簡単なアプローチは、特定の名前に一致する新しいプロセスの起動をデバッガに監視させることです。例えば：

```
(gdb) attach -w -n julia-debug
```

または:

```
(lldb) process attach -w -n julia-debug
```

次に、プリコンパイルを開始するためのスクリプト/コマンドを実行します。前述のように、親プロセスで条件付きブレークポイントを使用して特定のファイル読み込みイベントをキャッチし、デバッグウィンドウを絞り込みます。（一部のオペレーティングシステムでは、親プロセスから各 `fork` を追跡するなどの代替アプローチが必要な場合があります）

## Mozilla's Record and Replay Framework (rr)

Juliaは現在、Mozillaの軽量記録および決定論的デバッグフレームワーク[rr](https://rr-project.org/)でボックスから出て動作します。これにより、実行のトレースを決定論的に再生することができます。再生された実行のアドレス空間、レジスタの内容、システムコールデータなどは、すべての実行で正確に同じです。

rrの最近のバージョン（3.1.0以上）が必要です。

### Reproducing concurrency bugs with rr

rrはデフォルトでシングルスレッドのマシンをシミュレートします。並行コードをデバッグするために、`rr record --chaos`を使用すると、rrはランダムに選ばれた1から8のコアの間でシミュレートします。したがって、`JULIA_NUM_THREADS=8`を設定し、バグを捕まえるまでrrの下でコードを再実行することをお勧めします。
