# [Workflow Tips](@id man-workflow-tips)

Juliaを効率よく使うためのヒントをいくつか紹介します。

## REPL-based workflow

[The Julia REPL](@ref)で説明したように、JuliaのREPLには、効率的な対話型ワークフローを実現する豊富な機能が備わっています。ここでは、コマンドラインでの作業をさらに快適にするヒントをいくつか紹介します。

### A basic editor/REPL workflow

Juliaで最も基本的な作業方法は、テキストエディタと`julia`コマンドラインを併用することです。

たとえば`Tmp.jl`というファイルを作成し、その中に次の内容を記述します。

```julia
module Tmp

say_hello() = println("Hello!")

# Your other definitions here

end # module

using .Tmp
```

次に、同じディレクトリでJuliaのREPLを起動します（`julia`コマンドを使用）。以下のように、新しいファイルを実行します。

```
julia> include("Tmp.jl")

julia> Tmp.say_hello()
Hello!
```

REPLでアイデアを試し、うまくいったものは`Tmp.jl`に保存します。ファイルを変更した後に再読み込みするには、もう一度`include`するだけです。

上記のポイントは、コードをモジュールにカプセル化することです。これにより、Juliaを再起動せずに`struct`の定義を編集したり、メソッドを削除したりできます。

（説明：`struct`は定義後に編集できず、メソッドも削除できません。しかし、モジュールの定義は上書きできます。再度`include("Tmp.jl")`するときに行っているのは、この操作です。）

また、コードをモジュールにカプセル化すると、REPLの以前の状態の影響を受けなくなるため、見つけにくいエラーを防げます。

## Browser-based workflow

ブラウザ上でJuliaを使う方法はいくつかあります。

  * [Pluto.jl](https://github.com/fonsp/Pluto.jl)を使ったPlutoノートブック
  * [IJulia.jl](https://github.com/JuliaLang/IJulia.jl)を使ったJupyterノートブック

## Revise-based workflows

REPLでもIJuliaでも、通常は[Revise](https://github.com/timholy/Revise.jl)を使うと開発環境を改善できます。[Revise documentation](https://timholy.github.io/Revise.jl/stable/)の手順に従い、Juliaの起動時にReviseが自動的に起動するよう設定するのが一般的です。設定後、Reviseは読み込み済みのすべてのモジュール内のファイルと、`includet`でREPLに読み込んだファイル（通常の`include`で読み込んだファイルは対象外）の変更を追跡します。そのため、Juliaのセッションを再起動しなくても、ファイルを編集すれば変更が反映されます。標準的なワークフローは上記のREPLを使う方法と似ていますが、次の点が異なります。

1. コードを、ロードパス上のどこかにあるモジュールに配置します。方法はいくつかありますが、推奨する方法は次の2つです。

     * 長期的に使うプロジェクトには、[PkgTemplates](https://github.com/invenia/PkgTemplates.jl)を使います。

       ```julia
       using PkgTemplates
       t = Template()
       t("MyPkg")
       ```

       これにより、`.julia/dev`ディレクトリに空のパッケージ`"MyPkg"`が作成されます。PkgTemplatesでは、コンストラクタ`Template`を通じてさまざまなオプションを設定できます。

       以下の手順2では、ソースコードを変更するには`MyPkg/src/MyPkg.jl`を、テストを変更するには`MyPkg/test/runtests.jl`を編集します。
     * 一時的なプロジェクトの場合は、一時ディレクトリ（例：`/tmp`）で作業すれば、後片付けの必要がありません。

       一時ディレクトリに移動してJuliaを起動し、次の操作を行います。

       ```julia-repl
       pkg> generate MyPkg            # type ] to enter pkg mode
       julia> push!(LOAD_PATH, pwd())   # hit backspace to exit pkg mode
       ```

       Juliaのセッションを再起動した場合は、`LOAD_PATH`を変更して、このコマンドをもう一度実行する必要があります。

       以下の手順2では、ソースコードを変更するには`MyPkg/src/MyPkg.jl`を編集し、テストファイルは任意の名前で作成します。
2. パッケージを開発します。

   コードを読み込む*前に*、Reviseが実行されていることを確認してください。たとえば、`using Revise`を実行するか、自動起動の設定方法についてドキュメントを参照してください。

   次に、テストファイルがあるディレクトリ（ここでは`"runtests.jl"`とします）に移動し、以下を実行します。

   ```julia-repl
   julia> using MyPkg

   julia> include("runtests.jl")
   ```

   エディタでMyPkgのコードを繰り返し変更し、`include("runtests.jl")`でテストを再実行できます。いくつかの[limitations](https://timholy.github.io/Revise.jl/stable/limitations/)を除き、変更を反映させるためにJuliaのセッションを再起動する必要は通常ありません。
