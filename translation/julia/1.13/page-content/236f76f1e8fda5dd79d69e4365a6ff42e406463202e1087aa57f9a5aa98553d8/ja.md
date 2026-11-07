# Eval of Julia code

Julia言語がコードをどのように実行するかを学ぶうえで、特に難しいのは、コードのブロックを実行するために、さまざまな要素がどのように連携するかを理解することです。

コードの各断片は通常、実行結果（期待どおりの結果になることを願いつつ）に至るまでに、なじみのない名前が付いた多くの段階を経ます。順不同で挙げると、flisp、AST、C++、LLVM、`eval`、`typeinf`、`macroexpand`、sysimg（またはシステムイメージ）、ブートストラップ、コンパイル、パース、実行、JIT、インタープリート、ボックス化、アンボックス化、組み込み関数、プリミティブ関数などです。

!!! sidebar "定義"
      * REPL

        REPLはRead-Eval-Print Loopの略です。コマンドライン環境を指す呼び名です。
      * AST

        Abstract Syntax Tree（抽象構文木）のことです。ASTはコード構造をデジタル表現したものです。この形式では、コードは意味に基づいてトークン化されており、操作や実行に適した状態になっています。


![コンパイラの処理フロー図](./img/compiler_diagram.png)

## Julia Execution

処理全体を大まかに見ると、次のようになります。

1. ユーザーが`julia`を起動します。
2. `cli/loader_exe.c`にあるC関数`main()`が呼び出されます。この関数はコマンドライン引数を処理し、`jl_options`構造体に値を設定するとともに、変数`ARGS`を設定します。続いて、[`julia_init` in `init.c`](https://github.com/JuliaLang/julia/blob/master/src/init.c)を呼び出してJuliaを初期化します（このとき、以前にコンパイルされた[sysimg](@ref dev-sysimg)が読み込まれる場合があります）。最後に、[`Base._start()`](https://github.com/JuliaLang/julia/blob/master/base/client.jl)を呼び出して、制御をJuliaに渡します。
3. `_start()`が制御を引き継ぐと、その後の処理はコマンドライン引数によって異なります。たとえば、ファイル名が指定されていれば、そのファイルの実行に進みます。指定されていなければ、対話型REPLを起動します。
4. REPLがユーザーとやり取りする仕組みの詳細は省きますが、最終的には実行対象のコードブロックが用意されます。
5. 実行するコードブロックがファイル内にある場合は、[`jl_load(char *filename)`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c)が呼び出されてファイルが読み込まれ、[parse](@ref dev-parsing)されます。その後、コードの各断片が`eval`に渡され、実行されます。
6. コードの各断片（またはAST）は、結果を得るために[`eval()`](@ref)へ渡されます。
7. [`eval()`](@ref)は、各コード断片を[`jl_toplevel_eval_flex()`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c)で実行しようとします。
8. `jl_toplevel_eval_flex()`は、そのコードが`using`や`module`のような「トップレベル」の処理かどうかを判定します。こうした処理は関数内では無効です。該当する場合、コードはトップレベルインタープリターに渡されます。
9. 次に`jl_toplevel_eval_flex()`がコードを[expands](@ref dev-macro-expansion)し、マクロをすべて展開するとともに、ASTを「lower」して実行しやすい形にします。
10. 次に`jl_toplevel_eval_flex()`が簡単なヒューリスティックを使い、ASTをJITコンパイルするか、そのまま直接インタープリートするかを判断します。
11. コードのインタープリート処理の大部分は、[`eval` in `interpreter.c`](https://github.com/JuliaLang/julia/blob/master/src/interpreter.c)が担います。
12. 一方、コードをコンパイルする場合、処理の大部分は`codegen.cpp`が担います。Juliaの関数が、ある引数型の組み合わせで初めて呼び出されるたびに、その関数に対して[type inference](@ref dev-type-inference)が実行されます。この情報は、[codegen](@ref dev-codegen)の段階で、より高速なコードを生成するために使われます。
13. やがてユーザーがREPLを終了するか、プログラムの末尾に到達すると、`_start()`メソッドが戻ります。
14. 終了直前に、`main()`が[`jl_atexit_hook(exit_code)`](https://github.com/JuliaLang/julia/blob/master/src/init.c)を呼び出します。これは`Base._atexit()`を呼び出し（Julia内で[`atexit()`](@ref)に登録された関数があれば、それらも呼び出します）、続いて[`jl_gc_run_all_finalizers()`](https://github.com/JuliaLang/julia/blob/master/src/gc.c)を呼び出します。最後に、すべての`libuv`ハンドルを適切にクリーンアップし、フラッシュされて閉じられるのを待ちます。

## [Parsing](@id dev-parsing)

デフォルトでは、Juliaは[JuliaSyntax.jl](https://github.com/JuliaLang/JuliaSyntax.jl)を使ってASTを生成します。以前は、femtolispで書かれた小さなLispプログラムを使っていました。そのソースコードはJuliaの[src/flisp](https://github.com/JuliaLang/julia/tree/master/src/flisp)に含まれています。環境変数`JULIA_USE_FLISP_PARSER`に`1`が設定されている場合は、代わりに旧パーサーが使われます。

## [Macro Expansion](@id dev-macro-expansion)

[`eval()`](@ref)はマクロに遭遇すると、式の評価を試みる前に、そのASTノードを展開します。マクロ展開では、Julia内の[`eval()`](@ref)から、`flisp`で書かれたパーサー関数`jl_macroexpand()`へ、さらに`fl_invoke_julia_macro()`を介してJuliaのマクロ本体（もちろんJuliaで書かれています）へと処理が渡され、再び戻ってきます。

通常、マクロ展開は[`Meta.lower()`](@ref)/`Core._lower()`の呼び出し時に最初の段階として行われますが、[`macroexpand()`](@ref)/`jl_macroexpand()`を直接呼び出して実行することもできます。

## [Type Inference](@id dev-type-inference)

Juliaの型推論は[`typeinf()` in `compiler/typeinfer.jl`](https://github.com/JuliaLang/julia/blob/master/base/compiler/typeinfer.jl)によって実装されています。型推論とは、Juliaの関数を調べ、各変数の型の上限と下限、および関数の戻り値の型の上限と下限を特定する処理です。これにより、既知の不変値のアンボックス化や、フィールドオフセットや関数ポインターの計算といった実行時処理のコンパイル時への繰り上げなど、さまざまな最適化が可能になります。型推論には、定数伝播やインライン化など、ほかの処理が含まれる場合もあります。

!!! sidebar "用語の補足"
      * JIT

        Just-In-Time Compilation（実行時コンパイル）のことです。必要になった時点で、ネイティブマシンコードをメモリ上に生成する処理を指します。
      * LLVM

        Low-Level Virtual Machine（低水準仮想マシン。コンパイラ）のことです。JuliaのJITコンパイラは、libLLVMというプログラム／ライブラリです。Juliaにおけるコード生成とは、JuliaのASTをLLVM命令に変換する処理と、LLVMがそれを最適化してネイティブアセンブリ命令に変換する処理の両方を指します。
      * C++

        LLVMが実装されているプログラミング言語です。そのため、コード生成もこの言語で実装されています。Juliaのライブラリの残りの部分はCで実装されています。これは一部には、Cの機能セットがより小さく、言語間のインターフェース層として使いやすいためです。
      * box

        値を取り、ガベージコレクター（gc）が追跡するデータを包むラッパーを割り当て、そのオブジェクトの型をタグ付けする処理を指します。
      * unbox

        値をボックス化する処理の逆です。型推論によってコンパイル時にデータの型が完全に分かっている場合、この処理によってデータをより効率的に操作できます。
      * generic function

        引数の型シグネチャに基づく動的ディスパッチによって選択される、複数の「メソッド」から構成されるJuliaの関数です。
      * anonymous function or "method"

        名前を持たず、型ディスパッチ機能もないJuliaの関数です。
      * primitive function

        Cで実装され、Juliaでは名前付きの関数「メソッド」として公開される関数です（ただし、匿名関数と同様に、ジェネリック関数のディスパッチ機能はありません）。
      * intrinsic function

        Juliaで関数として公開される低水準操作です。これらの擬似関数は、加算や符号拡張など、ほかの方法では直接表現できない生のビット列に対する操作を実装します。ビット列を直接操作するため、関数にコンパイルし、`Core.Intrinsics.box(T, ...)`の呼び出しで囲んで、値に型情報を再割り当てする必要があります。


## [JIT Code Generation](@id dev-codegen)

コード生成とは、JuliaのASTをネイティブマシンコードに変換する処理です。

JIT環境は、初期段階で[`jl_init_codegen` in `codegen.cpp`](https://github.com/JuliaLang/julia/blob/master/src/codegen.cpp)を呼び出して初期化されます。

必要に応じて、関数`emit_function(jl_method_instance_t*)`がJuliaのメソッドをネイティブ関数に変換します（注：MCJIT（LLVM v3.4以降）を使う場合、関数ごとに新しいモジュールへJITコンパイルする必要があります）。この関数は、関数全体の出力が完了するまで`emit_expr()`を再帰的に呼び出します。

このファイルの残りの大部分は、特定のコードパターンに対するさまざまな手動最適化に充てられています。たとえば、`emit_known_call()`は、さまざまな引数型の組み合わせに対して、[`builtins.c`](https://github.com/JuliaLang/julia/blob/master/src/builtins.c)で定義されている多くのプリミティブ関数をインライン化できます。

コード生成のほかの部分は、次のような各種ヘルパーファイルが担当します。

  * [`debuginfo.cpp`](https://github.com/JuliaLang/julia/blob/master/src/debuginfo.cpp)

    JIT関数のバックトレースを処理します。
  * [`ccall.cpp`](https://github.com/JuliaLang/julia/blob/master/src/ccall.cpp)

    ccallおよびllvmcallのFFIと、各種`abi_*.cpp`ファイルを処理します。
  * [`intrinsics.cpp`](https://github.com/JuliaLang/julia/blob/master/src/intrinsics.cpp)

    さまざまな低水準組み込み関数の出力を処理します。

!!! sidebar "ブートストラップ"
    新しいシステムイメージを作成する処理を「ブートストラップ」と呼びます。

    この語は「ブーツのつまみを引っ張って自分を持ち上げる」という表現に由来し、利用できる関数や定義がごく限られた状態から始めて、最終的に機能がそろった環境を作り上げるという考えを表しています。


## [System Image](@id dev-sysimg)

システムイメージは、Juliaのファイル群を事前コンパイルしてまとめたアーカイブです。Juliaに同梱されている`sys.ji`ファイルもその一つで、[`sysimg.jl`](https://github.com/JuliaLang/julia/blob/master/base/sysimg.jl)ファイルを実行し、その結果の環境（型、関数、モジュール、その他定義されたすべての値を含む）をシリアライズしてファイルに保存することで生成されます。そのため、ブートストラップ終了時の環境に含まれていた`Main`、`Core`、`Base`モジュール（およびその他の要素）の固定された状態が含まれています。このシリアライザー／デシリアライザーは[`jl_save_system_image`/`jl_restore_system_image` in `staticdata.c`](https://github.com/JuliaLang/julia/blob/master/src/staticdata.c)によって実装されています。

sysimgファイル（`jl_options.image_file == NULL`）が存在しない場合、コマンドラインで`--build`が指定されたことも意味します。そのため、最終的には新しいsysimgファイルが作成されるはずです。Juliaの初期化中に、最小限の`Core`モジュールと`Main`モジュールが作成されます。次に、カレントディレクトリにある`boot.jl`という名前のファイルが評価されます。その後、コマンドライン引数で指定されたファイルがあれば、末尾に達するまで順に評価されます。最後に、生成された環境が「sysimg」ファイルに保存され、次回Juliaを起動するときの初期状態として使われます。
