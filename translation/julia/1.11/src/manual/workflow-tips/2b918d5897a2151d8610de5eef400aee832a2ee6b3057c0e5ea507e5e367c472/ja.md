# [Workflow Tips](@id man-workflow-tips)

ここにJuliaを効率的に使うためのいくつかのヒントがあります。

## REPL-based workflow

既に [The Julia REPL](@ref) で詳述したように、JuliaのREPLは効率的なインタラクティブワークフローを促進する豊富な機能を提供します。ここでは、コマンドラインでの体験をさらに向上させるためのいくつかのヒントを紹介します。

### A basic editor/REPL workflow

最も基本的なJuliaのワークフローは、テキストエディタを`julia`コマンドラインと組み合わせて使用することです。

ファイルを作成します。例えば `Tmp.jl` という名前で、その中に以下を含めます。

```julia
module Tmp

say_hello() = println("Hello!")

# Your other definitions here

end # module

using .Tmp
```

次に、同じディレクトリで、Julia REPLを起動します（`julia`コマンドを使用）。新しいファイルを次のように実行します：

```
julia> include("Tmp.jl")

julia> Tmp.say_hello()
Hello!
```

REPLでアイデアを探求します。良いアイデアは`Tmp.jl`に保存します。ファイルが変更された後に再読み込みするには、再度`include`するだけです。

上記の重要な点は、あなたのコードがモジュールにカプセル化されていることです。これにより、`struct` 定義を編集したり、メソッドを削除したりしても、Juliaを再起動することなく行うことができます。

（説明：`struct`は定義後に編集できず、メソッドを削除することもできません。しかし、モジュールの定義を上書きすることは可能であり、これは`include("Tmp.jl")`を再度行うときに行うことです。）

さらに、モジュール内でのコードのカプセル化は、REPL内の以前の状態に影響されることからコードを保護し、検出が難しいエラーからあなたを守ります。

## Browser-based workflow

ブラウザでJuliaと対話する方法はいくつかあります：

  * [Pluto.jl](https://github.com/fonsp/Pluto.jl)を通じてPlutoノートブックを使用する
  * Jupyterノートブックを使用するには、[IJulia.jl](https://github.com/JuliaLang/IJulia.jl)

## Revise-based workflows

REPLまたはIJuliaにいるとき、通常は[Revise](https://github.com/timholy/Revise.jl)を使用して開発体験を向上させることができます。juliaが起動するたびにReviseを開始するように設定することが一般的であり、これは[Revise documentation](https://timholy.github.io/Revise.jl/stable/)の指示に従います。設定が完了すると、Reviseは読み込まれたモジュール内のファイルの変更や、`includet`を使用してREPLに読み込まれたファイルの変更を追跡します（通常の`include`ではありません）。その後、ファイルを編集すると、juliaセッションを再起動することなく変更が反映されます。標準的なワークフローは、上記のREPLベースのワークフローに似ており、以下の修正があります：

1. コードをロードパス上のどこかにモジュールとして配置してください。これを実現するためのいくつかのオプションがあり、その中で推奨される2つの選択肢は次のとおりです：

      * 長期プロジェクトには [PkgTemplates](https://github.com/invenia/PkgTemplates.jl) を使用してください:

        ```julia
        using PkgTemplates
        t = Template()
        t("MyPkg")
        ```

        これにより、あなたの `.julia/dev` ディレクトリに空のパッケージ `"MyPkg"` が作成されます。PkgTemplatesを使用すると、その `Template` コンストラクタを通じて多くの異なるオプションを制御できることに注意してください。

        ステップ2では、`MyPkg/src/MyPkg.jl`を編集してソースコードを変更し、`MyPkg/test/runtests.jl`をテストのために編集します。
      * 「使い捨て」プロジェクトの場合、一時ディレクトリ（例：`/tmp`）で作業を行うことで、クリーンアップの必要を回避できます。

        一時ディレクトリに移動し、Juliaを起動して、次の操作を行ってください：

        ```julia-repl
        pkg> generate MyPkg            # type ] to enter pkg mode
        julia> push!(LOAD_PATH, pwd())   # hit backspace to exit pkg mode
        ```

        Juliaセッションを再起動すると、`LOAD_PATH`を変更するそのコマンドを再度発行する必要があります。

        ステップ2では、`MyPkg/src/MyPkg.jl`を編集してソースコードを変更し、任意のテストファイルを作成します。
2. パッケージを開発する

    *コード*を読み込む前に、Reviseを実行していることを確認してください：`using Revise`と入力するか、自動的に実行するための設定に関するドキュメントを参照してください。

    次に、テストファイル（ここでは `"runtests.jl"` と仮定）を含むディレクトリに移動し、次の操作を行います：

    ```julia-repl
    julia> using MyPkg

    julia> include("runtests.jl")
    ```

    You can iteratively modify the code in MyPkg in your editor and re-run the tests with `include("runtests.jl")`.  You generally should not need to restart your Julia session to see the changes take effect (subject to a few [limitations](https://timholy.github.io/Revise.jl/stable/limitations/)).
