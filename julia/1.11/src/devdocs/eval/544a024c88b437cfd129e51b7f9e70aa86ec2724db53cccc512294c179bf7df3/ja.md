# Eval of Julia code

Julia言語がコードを実行する仕組みを学ぶ上で最も難しい部分の一つは、コードのブロックを実行するためにすべての要素がどのように連携しているかを学ぶことです。

各コードのチャンクは、通常、次のような潜在的に馴染みのない名前を持つ多くのステップを経ます（順不同）：flisp、AST、C++、LLVM、`eval`、`typeinf`、`macroexpand`、sysimg（またはシステムイメージ）、ブートストラップ、コンパイル、パース、実行、JIT、解釈、ボックス、アンボックス、内蔵関数、プリミティブ関数など、最終的に望ましい結果（できれば）に変わります。

!!! sidebar "Definitions"
      * REPL

        REPLはRead-Eval-Print Loopの略です。これは、コマンドライン環境を短く呼ぶための名称です。
      * AST

        抽象構文木（AST）ASTはコード構造のデジタル表現です。この形式では、コードは意味のためにトークン化されており、操作や実行により適しています。


![コンパイラフローの図](./img/compiler_diagram.png)

## Julia Execution

全体プロセスの10,000フィートの視点は次のとおりです：

1. ユーザーは `julia` を開始します。
2. `cli/loader_exe.c` の C 関数 `main()` が呼び出されます。この関数はコマンドライン引数を処理し、`jl_options` 構造体を埋め、変数 `ARGS` を設定します。その後、Julia を初期化します（[`julia_init` in `init.c`](https://github.com/JuliaLang/julia/blob/master/src/init.c) を呼び出すことによって、以前にコンパイルされた [sysimg](@ref dev-sysimg) をロードする可能性があります）。最後に、[`Base._start()`](https://github.com/JuliaLang/julia/blob/master/base/client.jl) を呼び出すことによって、制御を Julia に渡します。
3. `_start()` が制御を引き継ぐと、その後のコマンドのシーケンスは与えられたコマンドライン引数に依存します。たとえば、ファイル名が指定されている場合、それを実行します。そうでない場合は、インタラクティブな REPL を開始します。
4. ユーザーとのREPLのインタラクションに関する詳細は省略しますが、プログラムは実行したいコードのブロックを持つことになります。
5. ファイルに実行するコードのブロックがある場合、[`jl_load(char *filename)`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c)がファイルをロードするために呼び出され、[parse](@ref dev-parsing)がそれを実行します。各コードのフラグメントはその後、`eval`に渡されて実行されます。
6. 各コードの断片（またはAST）は、[`eval()`](@ref) に渡されて結果に変換されます。
7. [`eval()`](@ref) は各コードフラグメントを取り出し、[`jl_toplevel_eval_flex()`](https://github.com/JuliaLang/julia/blob/master/src/toplevel.c) で実行しようとします。
8. `jl_toplevel_eval_flex()` は、コードが「トップレベル」のアクション（`using` や `module` など）であるかどうかを判断します。これは関数内では無効です。もしそうであれば、コードをトップレベルインタープリタに渡します。
9. `jl_toplevel_eval_flex()` その後 [expands](@ref dev-macro-expansion) マクロを排除し、ASTを「単純化」して実行しやすくするためのコードです。
10. `jl_toplevel_eval_flex()` は、ASTをJITコンパイルするか、直接解釈するかを決定するために、いくつかの単純なヒューリスティックを使用します。
11. コードを解釈する作業の大部分は [`eval` in `interpreter.c`](https://github.com/JuliaLang/julia/blob/master/src/interpreter.c) によって処理されます。
12. もし代わりにコードがコンパイルされると、作業の大部分は `codegen.cpp` によって処理されます。特定の引数の型のセットで初めて呼び出されると、[type inference](@ref dev-type-inference) がその関数で実行されます。この情報は、[codegen](@ref dev-codegen) ステップによってより高速なコードを生成するために使用されます。
13. 最終的に、ユーザーはREPLを終了するか、プログラムの終わりに達し、`_start()`メソッドが戻ります。
14. 終了する直前に、`main()`は[`jl_atexit_hook(exit_code)`](https://github.com/JuliaLang/julia/blob/master/src/init.c)を呼び出します。 これにより、`Base._atexit()`（Julia内で[`atexit()`](@ref)に登録された関数を呼び出します）が呼び出されます。 次に、[`jl_gc_run_all_finalizers()`](https://github.com/JuliaLang/julia/blob/master/src/gc.c)が呼び出されます。 最後に、すべての`libuv`ハンドルを優雅にクリーンアップし、それらがフラッシュして閉じるのを待ちます。

## [Parsing](@id dev-parsing)

Juliaパーサーは、femtolispで書かれた小さなlispプログラムであり、そのソースコードはJulia内の[src/flisp](https://github.com/JuliaLang/julia/tree/master/src/flisp)に配布されています。

このインターフェース機能は主に [`jlfrontend.scm`](https://github.com/JuliaLang/julia/blob/master/src/jlfrontend.scm) で定義されています。 [`ast.c`](https://github.com/JuliaLang/julia/blob/master/src/ast.c) のコードは、Julia 側でこのハンドオフを処理します。

この段階での他の関連ファイルは [`julia-parser.scm`](https://github.com/JuliaLang/julia/blob/master/src/julia-parser.scm) で、これはJuliaコードをトークン化し、ASTに変換する処理を行います。また、[`julia-syntax.scm`](https://github.com/JuliaLang/julia/blob/master/src/julia-syntax.scm) は、複雑なAST表現をより単純な「低下」AST表現に変換する処理を行い、分析や実行により適したものにします。

フロントエンドを単独で実行することで、Juliaを完全に再構築することなくパーサーをテストすることができます。次のように実行してください：

```
$ cd src
$ flisp/flisp
> (load "jlfrontend.scm")
> (jl-parse-file "<filename>")
```

## [Macro Expansion](@id dev-macro-expansion)

[`eval()`](@ref) がマクロに遭遇すると、そのASTノードを展開してから式の評価を試みます。マクロ展開は、`4d61726b646f776e2e436f64652822222c20226576616c28292229_40726566`（Juliaで）から、パーサ関数 `jl_macroexpand()`（`flisp`で書かれた）を経て、Juliaマクロ自体（他に何があるのか - Juliaで書かれた）に `fl_invoke_julia_macro()` を介して渡され、再び戻ります。

通常、マクロ展開は、[`Meta.lower()`](@ref)/`jl_expand()`への呼び出しの最初のステップとして呼び出されますが、[`macroexpand()`](@ref)/`jl_macroexpand()`への直接の呼び出しによっても呼び出すことができます。

## [Type Inference](@id dev-type-inference)

型推論は、[`typeinf()` in `compiler/typeinfer.jl`](https://github.com/JuliaLang/julia/blob/master/base/compiler/typeinfer.jl)によって実装されています。型推論は、Julia関数を調べ、その変数の各々の型の境界を決定し、関数からの戻り値の型の境界を決定するプロセスです。これにより、既知の不変値のアンボックス化や、フィールドオフセットや関数ポインタの計算など、さまざまなランタイム操作のコンパイル時のホイストなど、多くの将来の最適化が可能になります。型推論には、定数伝播やインライン化などの他のステップも含まれる場合があります。

!!! sidebar "More Definitions"
      * JIT

        ジャストインタイムコンパイル 必要なときにネイティブマシンコードをメモリに生成するプロセス。
      * LLVM

        Low-Level Virtual Machine (コンパイラ) Julia JITコンパイラはlibLLVMと呼ばれるプログラム/ライブラリです。Juliaにおけるコード生成は、JuliaのASTをLLVM命令に変換するプロセスと、LLVMがそれを最適化してネイティブアセンブリ命令に変換するプロセスの両方を指します。
      * C++

        LLVMが実装されているプログラミング言語、つまりコード生成もこの言語で実装されています。Juliaのライブラリの残りはCで実装されており、その理由の一部は、機能セットが小さいため、クロス言語インターフェース層としてより使いやすくなるからです。
      * ボックス

        この用語は、値を取得し、ガベージコレクタ（gc）によって追跡され、オブジェクトの型でタグ付けされたデータの周りにラッパーを割り当てるプロセスを説明するために使用されます。
      * アンボックス

        値をボクシングする逆操作です。この操作により、データの型がコンパイル時に完全に知られている場合（型推論を通じて）、データのより効率的な操作が可能になります。
      * 汎用関数

        複数の「メソッド」で構成され、引数の型シグネチャに基づいて動的ディスパッチのために選択されるJulia関数
      * 匿名関数または「メソッド」

        無名で型ディスパッチ機能のないJulia関数
      * 原始関数

        Cで実装された関数が、ジェネリック関数ディスパッチ機能はないものの、無名関数に似た形でJuliaで「method」という名前の関数として公開される。
      * 内在関数

        Juliaで関数として公開されている低レベルの操作。これらの擬似関数は、直接他の方法で表現できない生のビットに対する加算や符号拡張などの操作を実装しています。ビットに直接作用するため、関数にコンパイルされ、値に型情報を再割り当てするために`Core.Intrinsics.box(T, ...)`の呼び出しで囲む必要があります。


## [JIT Code Generation](@id dev-codegen)

Codegenは、JuliaのASTをネイティブマシンコードに変換するプロセスです。

JIT環境は、[`jl_init_codegen` in `codegen.cpp`](https://github.com/JuliaLang/julia/blob/master/src/codegen.cpp)への早期呼び出しによって初期化されます。

要求に応じて、Juliaメソッドは`emit_function(jl_method_instance_t*)`関数によってネイティブ関数に変換されます。（注：MCJIT（LLVM v3.4以降）を使用する場合、各関数は新しいモジュールにJITされなければなりません。）この関数は、関数全体が出力されるまで再帰的に`emit_expr()`を呼び出します。

このファイルの残りの大部分は、特定のコードパターンのさまざまな手動最適化に専念しています。たとえば、`emit_known_call()`は、さまざまな引数の型の組み合わせに対して多くのプリミティブ関数をインライン化する方法を知っています（[`builtins.c`](https://github.com/JuliaLang/julia/blob/master/src/builtins.c)）。

コード生成の他の部分は、さまざまなヘルパーファイルによって処理されます：

  * [`debuginfo.cpp`](https://github.com/JuliaLang/julia/blob/master/src/debuginfo.cpp)

    JIT関数のバックトレースを処理します
  * [`ccall.cpp`](https://github.com/JuliaLang/julia/blob/master/src/ccall.cpp)

    `ccall` と `llvmcall` FFI、およびさまざまな `abi_*.cpp` ファイルを処理します。
  * [`intrinsics.cpp`](https://github.com/JuliaLang/julia/blob/master/src/intrinsics.cpp)

    さまざまな低レベルの内在関数の発行を処理します

!!! sidebar "Bootstrapping"
    新しいシステムイメージを作成するプロセスは「ブートストラップ」と呼ばれます。

    この単語の語源は「ブーツストラップで自分を引き上げる」というフレーズに由来し、非常に限られた機能と定義のセットから始まり、完全な機能を持つ環境を作り出すという考えを指します。


## [System Image](@id dev-sysimg)

システムイメージは、一連のJuliaファイルのプリコンパイルされたアーカイブです。Juliaに付属する`sys.ji`ファイルは、そのようなシステムイメージの一例であり、ファイル[`sysimg.jl`](https://github.com/JuliaLang/julia/blob/master/base/sysimg.jl)を実行し、結果として得られた環境（タイプ、関数、モジュール、および定義されたすべての値を含む）をファイルにシリアライズすることによって生成されます。したがって、ブートストラップの最後に環境にあった`Main`、`Core`、および`Base`モジュールのフリーズされたバージョンが含まれています。このシリアライザー/デシリアライザーは、[`jl_save_system_image`/`jl_restore_system_image` in `staticdata.c`](https://github.com/JuliaLang/julia/blob/master/src/staticdata.c)によって実装されています。

もしsysimgファイルが存在しない場合（`jl_options.image_file == NULL`）、これはコマンドラインで`--build`が指定されたことを意味しますので、最終的な結果は新しいsysimgファイルになります。Juliaの初期化中に、最小限の`Core`および`Main`モジュールが作成されます。その後、現在のディレクトリから`boot.jl`という名前のファイルが評価されます。Juliaはコマンドライン引数として与えられたファイルを評価し続け、最後に達します。最後に、結果の環境を将来のJulia実行の出発点として使用するために「sysimg」ファイルに保存します。
