# Improving documentation

*Juliaのドキュメントに貢献すると、その内容を[MIT License](https://github.com/JuliaLang/julia/tree/master/LICENSE.md)のライセンスで公開することに同意したものとみなされます。*

Juliaのドキュメントのソースファイルは`doc/`ディレクトリにあり、すべてのdocstringは`base/`にあります。ほかのファイルと同様、これらも`git`を使って変更できます。ドキュメントのビルドには、Markdown構文を使う[Documenter.jl](https://github.com/JuliaDocs/Documenter.jl)を使用します。HTMLドキュメントは、Juliaのルートディレクトリで次のコマンドを実行するとローカルでビルドできます。

```
make docs
```

このコマンドは、Juliaのシステムイメージを再ビルドし、ドキュメントのビルドに必要なパッケージ依存関係をインストールまたは更新した後、HTMLドキュメントをビルドして、生成されたファイルを`doc/_build/html/`に配置します。

> **注**
>
> Juliaのドキュメントを変更した場合は、プルリクエストを作成する前に`make docs`を実行し、変更が有効でエラーを引き起こさないことを確認することをおすすめします。


以下では、最も一般的な3種類のドキュメント変更と、それぞれに必要な手順を説明します。なお、以下の手順ではDocumenter.jlが提供するすべての機能を網羅しているわけではありません。ここに記載されていない内容については、[Documenter's documentation](https://juliadocs.github.io/Documenter.jl/stable)を参照してください。

## Modifying files in `doc/src/`

Juliaマニュアルのソーステキストの大部分は`doc/src/`にあります。既存ファイルのテキストを更新または追加するには、次の手順に従います。

1. 該当する`.md`ファイルのテキストを更新する。
2. ルートディレクトリで`make docs`を実行する。
3. `doc/_build/html/`の出力を確認し、変更が正しいことを確かめる。
4. 変更をコミットし、プルリクエストを作成する。

> **注**
>
> 変更を加えた場合でも、`doc/_build/`の内容をコミットする必要は**ありません**。


ファイルを更新するのではなく、`doc/src/`に**新しいファイル**を追加する場合は、上記の手順`1`を次の手順に置き換えます。

1. 適切な`doc/src/`サブディレクトリにファイルを追加し、`doc/make.jl`内の`PAGES`ベクターにもファイルパスを追加する。

## Modifying an existing docstring in `base/`

docstringは、対象となるメソッドや型の直前にインラインで記述されています。HTMLファイルで各docstringの下に表示される`source`リンクをクリックすると、その場所を確認できます。既存のdocstringを変更する手順は次のとおりです。

1. `base/`でdocstringを見つける。
2. docstringのテキストを更新する。
3. ルートディレクトリで`make docs`を実行する。
4. `doc/_build/html/`の出力を確認し、変更が正しいことを確かめる。
5. 変更をコミットし、プルリクエストを作成する。

## Adding a new docstring to `base/`

新しいdocstringを追加するには、次の手順に従います。

1. docstringの対象として最も適切な定義を`base/`で見つける。
2. 定義の直前にdocstringを追加する。
3. docstringを表示したい`doc/src/stdlib/`ファイルのいずれかで、適切な`@docs`コードブロックを見つける。
4. 定義名を`@docs`コードブロックに追加する。たとえば、関数`bar`にdocstringを追加した場合、

   `julia  "..."  function bar(args...)      # ...  end`

   `@docs`ブロック内の`bar`という名前を、`doc/src/stdlib/`に追加します。

   ```
    ```@docs
    foo
    bar # <-- Added this one.
    baz
    ```
   ```
5. ルートディレクトリで`make docs`を実行する。
6. `doc/_build/html`の出力を確認し、変更が正しいことを確かめる。
7. 変更をコミットし、プルリクエストを作成する。

## Doctests

docstring内の例は、コードブロックに`jldoctest`を付けることで、「doctest」と呼ばれるテストケースとして実行できます。

````
```jldoctest
julia> uppercase("Docstring test")
"DOCSTRING TEST"
```
````

doctestは、`julia>`プロンプトを含む対話型REPLと一致している必要があります。doctestの前に`# Examples`ヘッダーを追加することをおすすめします。

一般的なケースでのdoctestの書き方については、ベストプラクティスを説明した[writing jldoctests](@ref writing-jldoctests)のドキュメントを参照してください。また、doctestの実行方法については`doc/README.md`ファイルを参照してください。
