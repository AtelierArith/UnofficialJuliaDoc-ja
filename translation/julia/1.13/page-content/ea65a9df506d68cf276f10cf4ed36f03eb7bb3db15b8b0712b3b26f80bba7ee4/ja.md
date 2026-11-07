```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/Markdown/docs/src/index.md"
```

# [Markdown](@id markdown_stdlib)

このセクションでは、Markdown 標準ライブラリによって有効になる Julia の Markdown 構文について説明します。以下の Markdown 要素がサポートされています。

## Inline elements

ここで「インライン」とは、段落などのテキストブロック内に記述できる要素を指します。次の要素が含まれます。

### Bold

単語を2つのアスタリスク `**` で囲むと、その部分が太字で表示されます。

```
A paragraph containing a **bold** word.
```

### Italics

単語を1つのアスタリスク `*` で囲むと、その部分が斜体で表示されます。

```
A paragraph containing an *italicized* word.
```

### Literals

記述したとおりに表示したいテキストは、1つのバッククォート ``` ` ``` で囲みます。

```
A paragraph containing a `literal` word.
```

Julia プログラムの変数名、関数名、その他の要素に言及するテキストを書く場合は、リテラルを使用します。

!!! tip
    リテラルテキスト内にバッククォート文字を含めるには、テキストを囲むのに1つではなく3つのバッククォートを使います。

    ```
    A paragraph containing ``` `backtick` characters ```.
    ```

    同様に、囲む対象よりも多い奇数個のバッククォートで囲むこともできます。


### $\LaTeX$

数式として表示するテキストは、``\LaTeX`` 構文を使い、2つのバッククォート ``` `` ``` で囲みます。

```
A paragraph containing some ``\LaTeX`` markup.
```

!!! tip
    前のセクションのリテラルと同様に、二重バッククォート内にリテラルのバッククォートを記述する場合は、2個より多い偶数個のバッククォートを使います。``\LaTeX`` マークアップ内にリテラルのバッククォートを1つだけ含める場合は、囲むバッククォートが2つあれば十分です。


!!! note
    テキストを Julia のソースコードに埋め込む場合、たとえば ```"``\\LaTeX`` syntax in a docstring."``` のように、`\` 文字を適切にエスケープする必要があります。これは文字列リテラルとして解釈されるためです。エスケープを避けるには、`raw` 文字列マクロと `@doc` マクロを組み合わせて使う方法もあります。

    ```
    @doc raw"``\LaTeX`` syntax in a docstring." functionname
    ```


### Links

外部または内部のリンク先へのリンクは、次の構文で記述できます。角括弧で囲まれたテキスト `[ ]` がリンク名、丸括弧で囲まれたテキスト `( )` が URL です。

```
A paragraph containing a link to [Julia](https://www.julialang.org).
```

Julia のドキュメント内で、ドキュメント化された他の関数、メソッド、変数への相互参照を追加することもできます。たとえば、次のように記述します。

```julia
"""
    tryparse(type, str; base)

Like [`parse`](@ref), but returns either a value of the requested type,
or [`nothing`](@ref) if the string does not contain a valid number.
"""
```

これにより、生成されたドキュメント内に [`parse`](@ref) のドキュメント（この関数の動作について詳しく説明しています）と、[`nothing`](@ref) のドキュメントへのリンクが作成されます。関数の変更あり／変更なしのバージョンを相互参照したり、よく似た関数同士の違いを示したりすると便利です。

!!! note
    上記の相互参照は Markdown の機能ではなく、Julia のベースドキュメントのビルドに使われる [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) に依存しています。


### Footnote references

名前付きおよび番号付きの脚注参照は、次の構文で記述できます。脚注名は、句読点を含まない英数字1語でなければなりません。

```
A paragraph containing a numbered footnote [^1] and a named one [^named].
```

!!! note
    脚注に対応するテキストは、脚注参照と同じページ内であればどこに記述してもかまいません。脚注テキストの定義に使う構文については、下の [Footnotes](@ref) セクションで説明します。


## Toplevel elements

以下の要素は、ドキュメントの「トップレベル」または別の「トップレベル」要素内に記述できます。

### Paragraphs

段落は、上記の [Inline elements](@ref) セクションで定義したインライン要素を任意の数だけ含められる、プレーンテキストのブロックです。段落の前後には1行以上の空行を置きます。

```
This is a paragraph.

And this is *another* paragraph containing some emphasized text.
A new line, but still part of the same paragraph.
```

### Headers

見出しを使うと、ドキュメントを複数のセクションに分割できます。見出しは次の構文で記述します。

```julia
# Level One
## Level Two
### Level Three
#### Level Four
##### Level Five
###### Level Six
```

見出し行には、段落と同じように任意のインライン構文を含められます。

!!! tip
    1つのドキュメント内で見出しの階層を増やしすぎないようにしましょう。深くネストされたドキュメントは、構成を見直すか、別々のトピックを扱う複数のページに分割する必要があることを示している場合があります。


### Code blocks

次の例のように、4つのスペースまたは1つのタブでインデントすると、ソースコードをリテラルブロックとして表示できます。

```
This is a paragraph.

    function func(x)
        # ...
    end

Another paragraph.
```

また、コードブロックは3つのバッククォートで囲むこともできます。任意で「言語」を指定すると、コードブロックのシンタックスハイライトを設定できます。

````
A code block without a "language":

```
function func(x)
    # ...
end
```

and another one with the "language" specified as `julia`:

```julia
function func(x)
    # ...
end
```
````

!!! note
    最後の例のような「フェンス付き」コードブロックを、インデント付きコードブロックよりも優先して使ってください。インデント付きコードブロックでは、記述言語を指定できないためです。


### Block quotes

書籍やウェブサイトからの引用など、外部ソースのテキストは、引用する各行の先頭に `>` 文字を付けて、次のように引用できます。

```
Here's a quote:

> Julia is a high-level, high-performance dynamic programming language for
> technical computing, with syntax that is familiar to users of other
> technical computing environments.
```

各行では、`>` 文字の後に半角スペースを1つ置く必要があります。引用ブロック内には、他のトップレベル要素やインライン要素を含めることもできます。

### Images

画像の構文は、上記のリンク構文と似ています。リンクの先頭に `!` 文字を付けると、リンク先へのリンクではなく、指定した URL の画像が表示されます。

```julia
![alternative text](link/to/image.png)
```

### Lists

順序なしリストは、各項目の先頭に `*`、`+`、または `-` を付けて記述できます。

```
A list of items:

  * item one
  * item two
  * item three
```

各 `*` の前には半角スペースを2つ、後には半角スペースを1つ置くことに注意してください。

リストには、リストやコードブロック、引用ブロックなど、他のトップレベル要素をネストできます。リスト内にトップレベル要素を含める場合は、各リスト項目の間に空行を置きます。

```
Another list:

  * item one

  * item two

    ```
    f(x) = x
    ```

  * And a sublist:

      + sub-item one
      + sub-item two
```

!!! note
    リストの各項目の内容は、その項目の先頭行に揃える必要があります。上の例では、フェンス付きコードブロックを4つのスペースでインデントし、`item two` 内の `i` に揃える必要があります。


順序付きリストは、「箇条書き」文字 `*`、`+`、または `-` を、正の整数と `.` または `)` のいずれかに置き換えて記述します。

```
Two ordered lists:

 1. item one
 2. item two
 3. item three

 5) item five
 6) item six
 7) item seven
```

上の例の2つ目のリストのように、順序付きリストは1以外の番号から始めることもできます。順序なしリストと同様に、順序付きリストにもトップレベル要素をネストできます。

### Display equations

段落内に収まらない大きな ``\LaTeX`` の数式は、以下の例のように、「言語」として `math` を指定したフェンス付きコードブロックを使って、ディスプレイ数式として記述できます。

````julia
```math
f(a) = \frac{1}{2\pi}\int_{0}^{2\pi} (\alpha+R\cos(\theta))d\theta
```
````

### Footnotes

この構文は、[Footnote references](@ref) のインライン構文と対になっています。そちらのセクションも必ず読んでください。

脚注テキストは、脚注参照と似た次の構文で定義します。ただし、脚注ラベルの末尾に `:` 文字を付けます。

```
[^1]: Numbered footnote text.

[^note]:

    Named footnote text containing several toplevel elements
    indented by 4 spaces or one tab.

      * item one
      * item two
      * item three

    ```julia
    function func(x)
        # ...
    end
    ```
```

!!! note
    解析時に、すべての脚注参照に対応する脚注があるかどうかは検証されません。


### Horizontal rules

HTML の `<hr>` タグに相当するものは、ハイフン3つ（`---`）で記述できます。たとえば、次のようになります。

```
Text above the line.

---

And text below the line.
```

### Tables

基本的な表は、以下の構文で記述できます。Markdown の表は機能が限られており、上記の他の要素とは異なり、トップレベル要素をネストできません。使用できるのはインライン要素のみです。また、表には必ず列名を含むヘッダー行が必要です。セルを複数の行や列にまたがらせることはできません。

```
| Column One | Column Two | Column Three |
|:---------- | ---------- |:------------:|
| Row `1`    | Column `2` |              |
| *Row* 2    | **Row** 2  | Column ``3`` |
```

!!! note
    上の例のように、`|` 文字で構成される各列は、縦方向に揃える必要があります。

    列のヘッダー区切り行（`-` 文字を含む行）の両端に `:` 文字を置くと、その列の配置を左揃え、右揃え、または（両端に `:` がある場合）中央揃えに指定できます。`:` 文字を指定しない場合、列は既定で右揃えになります。


### Admonitions

アドモニションと呼ばれる、特別な書式のブロックを使うと、特定の注意事項を目立たせることができます。次の `!!!` 構文で定義できます。

```
!!! note

    This is the content of the note.
    It is indented by 4 spaces. A tab would work as well.

!!! warning "Beware!"

    And this is another one.

    This warning admonition has a custom title: `"Beware!"`.
```

`!!!` の後に続く最初の単語で、アドモニションの種類を指定します。特別なスタイルが適用される標準の種類があります。重大度の高い順に、`danger`、`warning`、`info`/`note`、`tip` です。

種類名に小文字のラテン文字（a-z）のみを使えば、独自のアドモニションの種類も使用できます。たとえば、次のような `terminology` ブロックを作成できます。

```
!!! terminology "julia vs Julia"

    Strictly speaking, "Julia" refers to the language,
    and "julia" to the standard implementation.
```

ただし、Markdown をレンダリングするコードがその種類を特別扱いしない限り、既定のスタイルが適用されます。

アドモニションの種類の後に文字列（二重引用符で囲む）を指定すると、ボックスに独自のタイトルを付けられます。タイトルを指定しない場合は、種類名がタイトルとして使われます（たとえば、`note` アドモニションでは `"Note"` がタイトルになります）。

アドモニションには、他の多くのトップレベル要素と同様に、リストや画像などのトップレベル要素を含めることができます。

## [Markdown String Literals](@id stdlib-markdown-literals)

`md""` マクロを使うと、Markdown 文字列を Julia コードに直接埋め込めます。このマクロは、Julia のソースファイルに Markdown 形式のテキストを簡単に含められるように設計されています。

### Usage

```julia
result = md"This is a **custom** Markdown string with [a link](http://example.com)."
```

## Markdown Syntax Extensions

Julia の Markdown は、基本的な文字列リテラルとよく似た方法で補間をサポートしています。ただし、補間されたオブジェクトを文字列に変換するのではなく、オブジェクト自体を Markdown ツリーに格納します。Markdown の内容をレンダリングすると、通常の `show` メソッドが呼び出され、通常どおりオーバーライドできます。この設計により、基本構文を複雑な機能（参照など）で煩雑にすることなく、Markdown を任意に拡張できます。

原理上は、パッケージによって Markdown パーサー自体を任意に拡張したり、完全に独自の Markdown 方言を使ったりすることもできますが、通常はその必要はありません。

## [API reference](@id stdlib-markdown-api)

```@docs
Markdown.MD
Markdown.@md_str
Markdown.@doc_str
Markdown.parse
Markdown.html
Markdown.latex
```
