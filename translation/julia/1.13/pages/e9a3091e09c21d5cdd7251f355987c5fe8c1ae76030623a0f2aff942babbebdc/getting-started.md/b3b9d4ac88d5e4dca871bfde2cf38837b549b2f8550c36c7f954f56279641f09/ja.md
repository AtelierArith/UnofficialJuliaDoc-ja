# [Getting Started](@id man-getting-started)

Juliaのインストールは、コンパイル済みバイナリを使う場合も、ソースからコンパイルする場合も簡単です。[https://julialang.org/install/](https://julialang.org/install/)の手順に従って、Juliaをダウンロードしてインストールしてください。

次のいずれかの言語からJuliaを使い始める場合は、まず[MATLAB](@ref Noteworthy-differences-from-MATLAB)、[R](@ref Noteworthy-differences-from-R)、[Python](@ref Noteworthy-differences-from-Python)、[C/C++](@ref Noteworthy-differences-from-C/C)、または[Common Lisp](@ref Noteworthy-differences-from-Common-Lisp)との主な違いを説明するセクションを読むとよいでしょう。Juliaはこれらの言語と微妙な点で多く異なるため、よくある落とし穴を避けるのに役立ちます。

Juliaを学び、試してみる最も簡単な方法は、Juliaの実行ファイルをダブルクリックするか、コマンドラインから`julia`を実行して、対話セッション（read-eval-print loop、略して「REPL」とも呼ばれます）を開始することです。

```@eval
using REPL
io = IOBuffer()
REPL.banner(io)
banner = takestring!(io)
import Markdown
Markdown.parse("```\n\$ julia\n\n$(banner)\njulia> 1 + 2\n3\n\njulia> ans\n3\n```")
```

対話セッションを終了するには、`CTRL-D`と入力します（Controlキーと`^`キーを押しながら、`d`キーを押します）。または、`exit()`と入力します。対話モードで実行すると、`julia`はバナーを表示し、入力を促します。`1 + 2`のような式を入力してEnterキーを押すと、対話セッションで式が評価され、その値が表示されます。式の末尾にセミコロンを付けて入力すると、値は表示されません。変数`ans`には、値が表示されたかどうかにかかわらず、最後に評価された式の値が割り当てられます。変数`ans`が割り当てられるのは対話セッション内だけで、ほかの方法でJuliaコードを実行した場合には割り当てられません。

ソースファイル`file.jl`に記述された式を評価するには、`include("file.jl")`と入力します。

ファイル内のコードを非対話的に実行するには、そのファイルを`julia`コマンドの最初の引数として指定します。

```
$ julia script.jl
```

Juliaとプログラム`script.jl`には、追加の引数を渡すこともできます。利用可能なオプションの一覧は、[Command-line Interface](@ref cli)にあります。

## Resources

Juliaを始めたばかりのユーザー向けに、役立つ学習リソースを厳選した一覧が、Julia公式サイトの[learning](https://julialang.org/learning/)ページにあります。

REPLを学習に活用するには、ヘルプモードに切り替えます。何も入力していない`julia>`プロンプトで、`?`を押すとヘルプモードになります。ヘルプモードでキーワードを入力すると、そのキーワードのドキュメントと例が表示されます。関数や、使っているうちに出会うほとんどのオブジェクトについても同様です。

```
help?> begin
search: begin disable_sigint reenable_sigint

  begin

  begin...end denotes a block of code.
```

Juliaをある程度知っている場合は、[Performance Tips](@ref man-performance-tips)や[Workflow Tips](@ref man-workflow-tips)を先に見てみるか、充実した[ModernJuliaWorkflows](https://modernjuliaworkflows.org/)ブログをチェックしてみてください。
