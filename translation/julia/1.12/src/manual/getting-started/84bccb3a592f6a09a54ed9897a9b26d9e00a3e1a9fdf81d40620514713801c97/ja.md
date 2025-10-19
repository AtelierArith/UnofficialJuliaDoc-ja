# [Getting Started](@id man-getting-started)

Juliaのインストールは簡単で、プリコンパイルされたバイナリを使用するか、ソースからコンパイルするかのいずれかです。[https://julialang.org/install/](https://julialang.org/install/)の指示に従ってJuliaをダウンロードしてインストールしてください。

もしあなたが以下の言語のいずれかからJuliaに来るのであれば、[MATLAB](@ref Noteworthy-differences-from-MATLAB)、[R](@ref Noteworthy-differences-from-R)、[Python](@ref Noteworthy-differences-from-Python)、[C/C++](@ref Noteworthy-differences-from-C/C)、または[Common Lisp](@ref Noteworthy-differences-from-Common-Lisp)のセクションを読むことから始めるべきです。これにより、Juliaがこれらの言語と多くの微妙な点で異なるため、一般的な落とし穴を避けるのに役立ちます。

Juliaを学び、実験する最も簡単な方法は、Juliaの実行可能ファイルをダブルクリックするか、コマンドラインから`julia`を実行してインタラクティブセッション（リード・エval・プリントループまたは「REPL」とも呼ばれます）を開始することです。

```@eval
using REPL
io = IOBuffer()
REPL.banner(io)
banner = String(take!(io))
import Markdown
Markdown.parse("```\n\$ julia\n\n$(banner)\njulia> 1 + 2\n3\n\njulia> ans\n3\n```")
```

インタラクティブセッションを終了するには、`CTRL-D`（Control/`^`キーと`d`キーを同時に押す）を入力するか、`exit()`と入力します。インタラクティブモードで実行されると、`julia`はバナーを表示し、ユーザーに入力を促します。ユーザーが`1 + 2`のような完全な式を入力し、エンターを押すと、インタラクティブセッションはその式を評価し、その値を表示します。式の末尾にセミコロンが付いている場合、その値は表示されません。変数`ans`は、表示されるかどうかにかかわらず、最後に評価された式の値にバインドされます。`ans`変数はインタラクティブセッションでのみバインドされ、他の方法でJuliaコードが実行されるときにはバインドされません。

`file.jl`というソースファイルに書かれた式を評価するには、`include("file.jl")`と書きます。

ファイル内のコードを非対話的に実行するには、`julia` コマンドの最初の引数として指定できます：

```
$ julia script.jl
```

追加の引数をJuliaおよびプログラム`script.jl`に渡すことができます。利用可能なすべてのオプションの詳細なリストは、[Command-line Interface](@ref cli)の下にあります。

## Resources

新しいユーザーが始めるための役立つ学習リソースのキュレーションされたリストは、メインのJuliaウェブサイトの [learning](https://julialang.org/learning/) ページで見つけることができます。

REPLを学習リソースとして使用するには、ヘルプモードに切り替えます。空の `julia>` プロンプトで何かを入力する前に `?` を押してヘルプモードに切り替えてください。ヘルプモードでキーワードを入力すると、それに関するドキュメントと例が取得されます。同様に、出会う可能性のあるほとんどの関数や他のオブジェクトについても同じです！

```
help?> begin
search: begin disable_sigint reenable_sigint

  begin

  begin...end denotes a block of code.
```

もしあなたがすでに少しJuliaを知っているなら、[Performance Tips](@ref man-performance-tips)や[Workflow Tips](@ref man-workflow-tips)を覗いてみるか、包括的な[ModernJuliaWorkflows](https://modernjuliaworkflows.org/)ブログをチェックしてみると良いでしょう。
