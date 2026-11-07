```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/Markdown/docs/src/index.md"
```

# [Markdown](@id markdown_stdlib)

このセクションでは、Markdown標準ライブラリによって有効になるJuliaのMarkdown構文について説明します。以下のMarkdown要素がサポートされています。

## Inline elements

ここで「インライン」とは、段落などのテキストブロック内に記述できる要素を指します。以下の要素が含まれます。

### Bold

単語を2つのアスタリスク`**`で囲むと、そのテキストが太字で表示されます。

```
A paragraph containing a **bold** word.
```

### Italics

単語を1つのアスタリスク`*`で囲むと、そのテキストが斜体で表示されます。

```
A paragraph containing an *italicized* word.
```

### Literals

記述したとおりに表示するテキストは、シングルバッククォート``` ` ```で囲みます。

```
A paragraph containing a `literal` word.
```

変数名、関数名、その他のJuliaプログラムの要素に言及するテキストを書く場合は、リテラルを使用してください。

!!! tip
    リテラルテキスト内にバッククォート文字を含めるには、テキストを囲むのに1つではなく3つのバッククォートを使います。

    ```
    A paragraph containing ``` `backtick` characters ```.
    ```

    同様に、囲まれるバッククォートよりも多い奇数個のバッククォートで囲むこともできます。


### $\LaTeX$

数式として表示するテキストは、``\LaTeX``構文を使い、ダブルバッククォート``` `` ```で囲みます。

```
A paragraph containing some ``\LaTeX`` markup.
```

!!! tip
    前のセクションのリテラルと同様に、ダブルバッククォート内にリテラルのバッククォートを書く必要がある場合は、2個より多い偶数個のバッククォートを使います。``\LaTeX``マークアップ内にリテラルのバッククォートを1つだけ含める場合は、囲むバッククォートが2つあれば十分です。


!!! note
    テキストをJuliaのソースコードに埋め込む場合、`\`文字は適切にエスケープする必要があります。たとえば```"``\\LaTeX`` syntax in a docstring."```のようにします。これは文字列リテラルとして解釈されるためです。エスケープを避けるには、`raw`文字列マクロと`@doc`マクロを組み合わせて使う方法もあります。

    ```
    @doc raw"``\LaTeX`` syntax in a docstring." functionname
    ```


### Links

外部または内部のリンク先へのリンクは、次の構文で記述できます。角括弧で囲まれたテキスト`[ ]`がリンク名、丸括弧で囲まれたテキスト`( )`がURLです。

```
A paragraph containing a link to [Julia](https://www.julialang.org).
```

Juliaのドキュメント内で、ドキュメント化された他の関数、メソッド、変数への相互参照を追加することもできます。たとえば、次のように記述します。

```julia
"""
    tryparse(type, str; base)

Like [`parse`](@ref), but returns either a value of the requested type,
or [`nothing`](@ref) if the string does not contain a valid number.
"""
```

これにより、生成されたドキュメント内で[`parse`](@ref)のドキュメント（この関数の実際の動作について詳しく説明しています）と、[`nothing`](@ref)のドキュメントへのリンクが作成されます。関数の破壊的バージョンと非破壊的バージョンを相互参照したり、よく似た2つの関数の違いを示したりするとよいでしょう。

!!! note
    上記の相互参照はMarkdownの機能ではありません。Julia本体のドキュメント構築に使われる[Documenter.jl](https://github.com/JuliaDocs/Documenter.jl)に依存しています。


### Footnote references

名前付きおよび番号付きの脚注参照は、次の構文で記述できます。脚注名は、句読点を含まない1つの英数字の単語でなければなりません。

```
A paragraph containing a numbered footnote [^1] and a named one [^named].
```

!!! note
    脚注に対応するテキストは、脚注参照と同じページ内であればどこにでも記述できます。脚注テキストの定義に使う構文については、後述の[Footnotes](@ref)セクションで説明します。


## Toplevel elements

以下の要素は、ドキュメントの「トップレベル」にも、別の「トップレベル」要素の中にも記述できます。

### Paragraphs

段落は、上記の[Inline elements](@ref)セクションで定義したインライン要素を任意の数だけ含められる、プレーンテキストのブロックです。段落の前後には、1行以上の空行を置きます。

```
This is a paragraph.

And this is *another* paragraph containing some emphasized text.
A new line, but still part of the same paragraph.
```

### Headers

ヘッダーを使うと、ドキュメントを複数のセクションに分割できます。ヘッダーは次の構文で記述します。

```julia
# Level One
## Level Two
### Level Three
#### Level Four
##### Level Five
###### Level Six
```

ヘッダー行には、段落と同じように、あらゆるインライン構文を含めることができます。

!!! tip
    1つのドキュメント内でヘッダーの階層を深くしすぎないようにしてください。階層が深すぎる場合は、構成を見直すか、トピックごとに複数のページへ分割する必要があるかもしれません。


### Code blocks

ソースコードは、次の例のように、4つのスペースまたは1つのタブでインデントすると、リテラルブロックとして表示できます。

```
This is a paragraph.

    function func(x)
        # ...
    end

Another paragraph.
```

また、コードブロックは3つのバッククォートで囲むこともできます。その際、任意で「言語」を指定すると、コードブロックのシンタックスハイライトを設定できます。

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

書籍やウェブサイトからの引用など、外部ソースのテキストは、引用する各行の先頭に`>`文字を付けて、次のように引用できます。

```
Here's a quote:

> Julia is a high-level, high-performance dynamic programming language for
> technical computing, with syntax that is familiar to users of other
> technical computing environments.
```

各行では、`>`文字の後にスペースを1つ置く必要があります。引用ブロックには、他のトップレベル要素やインライン要素を含めることもできます。

### Images

画像の構文は、前述のリンク構文と似ています。リンクの先頭に`!`文字を付けると、リンク先へのリンクではなく、指定したURLの画像が表示されます。

```julia
![alternative text](link/to/image.png)
```

### Lists

順序なしリストは、各項目の先頭に`*`、`+`、または`-`を付けて記述できます。

```
A list of items:

  * item one
  * item two
  * item three
```

各`*`の前にはスペースを2つ、後にはスペースを1つ置くことに注意してください。

リストには、リスト、コードブロック、引用ブロックなど、他のトップレベル要素を入れ子にして含めることができます。リスト項目内にトップレベル要素を含める場合は、各項目の間に空行を置いてください。

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
    リスト項目の内容は、項目の先頭行に揃える必要があります。上の例では、フェンス付きコードブロックを4つのスペースでインデントし、`item two`内の`i`に揃えます。


順序付きリストは、「箇条書き」文字`*`、`+`、または`-`を、正の整数と`.`または`)`のいずれかに置き換えて記述します。

```
Two ordered lists:

 1. item one
 2. item two
 3. item three

 5) item five
 6) item six
 7) item seven
```

上の例の2つ目のリストのように、順序付きリストは1以外の番号から始めることもできます。この例では5から始まっています。順序なしリストと同様に、順序付きリストにもトップレベル要素を入れ子にして含められます。

### Display equations

段落内に収まらない大きな``\LaTeX``の式は、以下の例のように、「言語」として`math`を指定したフェンス付きコードブロックを使って、ディスプレイ数式として記述できます。

````julia
```math
f(a) = \frac{1}{2\pi}\int_{0}^{2\pi} (\alpha+R\cos(\theta))d\theta
```
````

### Footnotes

この構文は、[Footnote references](@ref)のインライン構文と対になっています。そちらのセクションも必ず読んでください。

脚注テキストは、脚注ラベルの末尾に`:`文字を付ける点を除き、脚注参照と同様の次の構文で定義します。

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

HTMLの`<hr>`タグに相当するものは、ハイフン3つ（`---`）で表せます。たとえば、次のように記述します。

```
Text above the line.

---

And text below the line.
```

### Tables

基本的な表は、以下で説明する構文で記述できます。Markdownの表は機能が限られており、上記の他の要素とは異なり、入れ子になったトップレベル要素を含めることはできません。インライン要素のみ使用できます。表には必ず列名を含むヘッダー行が必要です。セルを複数の行や列にまたがらせることはできません。

```
| Column One | Column Two | Column Three |
|:---------- | ---------- |:------------:|
| Row `1`    | Column `2` |              |
| *Row* 2    | **Row** 2  | Column ``3`` |
```

!!! note
    上の例のように、各列の`|`文字は縦に揃える必要があります。

    列のヘッダー区切り行（`-`文字を含む行）の両端にある`:`文字によって、その列の配置が左揃え、右揃え、または（両端に`:`がある場合）中央揃えに指定されます。`:`文字を指定しない場合、列は既定で右揃えになります。


### Admonitions

アドモニションと呼ばれる、特別な書式のブロックを使うと、特定の注意事項を強調できます。次の`!!!`構文で定義できます。

```
!!! note

    This is the content of the note.
    It is indented by 4 spaces. A tab would work as well.

!!! warning "Beware!"

    And this is another one.

    This warning admonition has a custom title: `"Beware!"`.
```

`!!!`の後に続く最初の単語で、アドモニションの種類を指定します。特別なスタイルが適用される標準の種類があります。重大度の高い順に、`danger`、`warning`、`info`/`note`、`tip`です。

種類名に小文字のラテン文字（a-z）のみを使えば、独自のアドモニションの種類も使用できます。たとえば、次のような`terminology`ブロックを作成できます。

```
!!! terminology "julia vs Julia"

    Strictly speaking, "Julia" refers to the language,
    and "julia" to the standard implementation.
```

ただし、Markdownをレンダリングするコードがその種類を特別に扱わない限り、既定のスタイルが適用されます。

アドモニションの種類の後に文字列を指定すると、ボックスのタイトルをカスタマイズできます（文字列は二重引用符で囲みます）。タイトルを指定しない場合は、種類名がタイトルとして使われます（たとえば、`note`アドモニションでは`"Note"`がタイトルになります）。

アドモニションには、他の多くのトップレベル要素と同様に、リストや画像などのトップレベル要素を含めることができます。

## [Markdown String Literals](@id stdlib-markdown-literals)

`md""`マクロを使うと、Markdown文字列をJuliaコードに直接埋め込めます。このマクロは、JuliaのソースファイルにMarkdown形式のテキストを簡単に含められるように設計されています。

### Usage

```julia
result = md"This is a **custom** Markdown string with [a link](http://example.com)."
```

## Markdown Syntax Extensions

JuliaのMarkdownは、基本的な文字列リテラルとよく似た方法で補間をサポートしています。ただし、オブジェクトを文字列に変換するのではなく、オブジェクト自体をMarkdownツリーに格納する点が異なります。Markdownコンテンツのレンダリング時には、通常の`show`メソッドが呼び出され、通常どおりオーバーライドできます。この設計により、基本構文を複雑にすることなく、参照などの任意に複雑な機能でMarkdownを拡張できます。

原理上は、パッケージによってMarkdownパーサー自体を任意に拡張することも、まったく独自のMarkdown方言を使うこともできますが、通常はその必要はありません。

## [API reference](@id stdlib-markdown-api)

```@docs
Markdown.MD
Markdown.@md_str
Markdown.@doc_str
Markdown.parse
Markdown.html
Markdown.latex
```
