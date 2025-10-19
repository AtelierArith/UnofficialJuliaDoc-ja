```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/Markdown/docs/src/index.md"
```

# [Markdown](@id markdown_stdlib)

このセクションでは、Markdown標準ライブラリによって有効にされるJuliaのMarkdown構文について説明します。次のMarkdown要素がサポートされています：

## Inline elements

ここで「インライン」とは、テキストのブロック、つまり段落内に見られる要素を指します。これには以下の要素が含まれます。

### Bold

単語を二つのアスタリスク `**` で囲むと、囲まれたテキストが太字で表示されます。

```
A paragraph containing a **bold** word.
```

### Italics

単語を一つのアスタリスク `*` で囲むと、囲まれたテキストがイタリック体で表示されます。

```
A paragraph containing an *italicized* word.
```

### Literals

テキストをそのまま表示する必要がある場合は、単一のバックティックで囲みます。 ``` ` ``` 。

```
A paragraph containing a `literal` word.
```

リテラルは、変数、関数、または他のJuliaプログラムの部分の名前を参照するテキストを書くときに使用する必要があります。

!!! tip
    リテラルテキスト内にバックティック文字を含めるには、テキストを囲むために1つではなく3つのバックティックを使用します。

    ```
    A paragraph containing ``` `backtick` characters ```.
    ```

    拡張として、奇数のバックティックを使用して、より少ない数のバックティックを囲むことができます。


### $\LaTeX$

数学として表示されるべきテキストは、$\LaTeX$構文を使用して二重バックスラッシュで囲みます。``` `` ``` 。

```
A paragraph containing some ``\LaTeX`` markup.
```

!!! tip
    前のセクションのリテラルと同様に、ダブルバックティック内にリテラルバックティックを書く必要がある場合は、2より大きい偶数を使用してください。単一のリテラルバックティックを$\LaTeX$マークアップ内に含める必要がある場合は、2つの囲むバックティックで十分です。


!!! note
    `\\` 文字は、テキストがJuliaソースコードに埋め込まれている場合、適切にエスケープする必要があります。例えば、 ```"``\\LaTeX`` 構文をドキュメント文字列に。"``` のように、文字列リテラルとして解釈されます。あるいは、エスケープを避けるために、`raw` 文字列マクロを `@doc` マクロと一緒に使用することも可能です。

    ```
    @doc raw"``\LaTeX`` syntax in a docstring." functionname
    ```


### Links

リンクは、外部または内部のターゲットに対して、次の構文を使用して記述できます。角括弧 `[ ]` で囲まれたテキストはリンクの名前であり、丸括弧 `( )` で囲まれたテキストはURLです。

```
A paragraph containing a link to [Julia](https://www.julialang.org).
```

Juliaのドキュメント内で、他の文書化された関数/メソッド/変数へのクロスリファレンスを追加することも可能です。例えば：

```julia
"""
    tryparse(type, str; base)

Like [`parse`](@ref), but returns either a value of the requested type,
or [`nothing`](@ref) if the string does not contain a valid number.
"""
```

これにより、生成されたドキュメントに [`parse`](@ref) ドキュメントへのリンクが作成されます（この関数が実際に何をするのかについての詳細情報があります）、および [`nothing`](@ref) ドキュメントへのリンクも作成されます。関数の変更版/非変更版への相互参照を含めたり、似ている2つの関数の違いを強調したりすることは良いことです。

!!! note
    上記の相互参照は*Markdownの機能ではなく*、[Documenter.jl](https://github.com/JuliaDocs/Documenter.jl)に依存しており、これは基本的なJuliaのドキュメントを構築するために使用されます。


### Footnote references

名前付きおよび番号付きの脚注参照は、次の構文を使用して記述できます。脚注名は、句読点を含まない単一の英数字の単語でなければなりません。

```
A paragraph containing a numbered footnote [^1] and a named one [^named].
```

!!! note
    脚注に関連付けられたテキストは、脚注参照と同じページ内のどこにでも記述できます。脚注テキストを定義するために使用される構文は、以下の [Footnotes](@ref) セクションで説明されています。


## Toplevel elements

次の要素は、ドキュメントの「トップレベル」または別の「トップレベル」要素内に記述できます。

### Paragraphs

段落は、上記の [Inline elements](@ref) セクションで定義された任意の数のインライン要素を含む可能性のあるプレーンテキストのブロックであり、その上と下に1つ以上の空行があります。

```
This is a paragraph.

And this is *another* paragraph containing some emphasized text.
A new line, but still part of the same paragraph.
```

### Headers

ドキュメントは、ヘッダーを使用して異なるセクションに分割できます。ヘッダーは次の構文を使用します：

```julia
# Level One
## Level Two
### Level Three
#### Level Four
##### Level Five
###### Level Six
```

ヘッダー行は、段落と同様に任意のインライン構文を含むことができます。

!!! tip
    ドキュメント内であまり多くのレベルのヘッダーを使用しないようにしましょう。過度にネストされたドキュメントは、再構成する必要があるか、別々のトピックをカバーするいくつかのページに分割する必要があることを示しているかもしれません。


### Code blocks

ソースコードは、以下の例に示すように、4つのスペースまたは1つのタブのインデントを使用してリテラルブロックとして表示できます。

```
This is a paragraph.

    function func(x)
        # ...
    end

Another paragraph.
```

さらに、コードブロックは三重のバックティックで囲むことができ、オプションで「言語」を指定してコードブロックのハイライト方法を指定できます。

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
    「フェンス付き」コードブロックは、最後の例に示されているように、インデントされたコードブロックよりも好まれるべきです。なぜなら、インデントされたコードブロックがどの言語で書かれているかを指定する方法がないからです。


### Block quotes

外部ソースからのテキスト、例えば書籍やウェブサイトからの引用は、次のように引用の各行の前に `>` 文字を追加して引用できます。

```
Here's a quote:

> Julia is a high-level, high-performance dynamic programming language for
> technical computing, with syntax that is familiar to users of other
> technical computing environments.
```

Markdown.Paragraph(Any["注意：各行の ", Markdown.Code("", ">"), " 文字の後には単一のスペースが必要です。引用ブロックには、他のトップレベルまたはインライン要素が含まれる場合があります。"])

### Images

画像の構文は、上記で述べたリンクの構文に似ています。リンクの前に `!` 文字を付けると、指定されたURLから画像が表示され、リンクではなくなります。

```julia
![alternative text](link/to/image.png)
```

### Lists

順不同リストは、リスト内の各項目の前に `*`、`+`、または `-` を付けることで作成できます。

```
A list of items:

  * item one
  * item two
  * item three
```

各 `*` の前に2つのスペース、後に1つのスペースがあることに注意してください。

リストには、リスト、コードブロック、または引用ブロックなどの他のネストされたトップレベル要素を含めることができます。リスト内にトップレベル要素を含める場合は、各リスト項目の間に空行を残す必要があります。

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
    リスト内の各項目の内容は、項目の最初の行に揃える必要があります。上記の例では、フェンシングコードブロックは `item two` の `i` に揃えるために4つのスペースでインデントされる必要があります。


順序付きリストは、「バレット」文字、すなわち `*`、`+`、または `-` を正の整数に置き換え、その後に `.` または `)` を続けて書きます。

```
Two ordered lists:

 1. item one
 2. item two
 3. item three

 5) item five
 6) item six
 7) item seven
```

番号付きリストは、上記の例の2番目のリストのように、1以外の数字から始めることができます。順不同リストと同様に、番号付きリストにはネストされたトップレベル要素を含めることができます。

### Display equations

大きな $\LaTeX$ 方程式は、段落内にインラインで収まらない場合、以下の例のように `math` という「言語」を使ったフェンシングコードブロックを使用して表示方程式として書くことができます。

````julia
```math
f(a) = \frac{1}{2\pi}\int_{0}^{2\pi} (\alpha+R\cos(\theta))d\theta
```
````

### Footnotes

この構文は、[Footnote references](@ref)のインライン構文とペアになっています。そのセクションも必ずお読みください。

脚注テキストは、脚注ラベルに追加される `:` 文字を除いて、脚注参照構文に似た以下の構文を使用して定義されます。

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
    パース中に、すべての脚注参照が一致する脚注を持っていることを確認するためのチェックは行われません。


### Horizontal rules

`<hr>` HTML タグの同等物は、3つのハイフン（`---`）を使用することで実現できます。例えば：

```
Text above the line.

---

And text below the line.
```

### Tables

基本的なテーブルは、以下に示す構文を使用して記述できます。マークダウンテーブルには制限された機能があり、上記で説明した他の要素とは異なり、ネストされたトップレベル要素を含むことはできません – インライン要素のみが許可されています。テーブルには常に列名を含むヘッダー行が必要です。セルはテーブルの複数の行や列にまたがることはできません。

```
| Column One | Column Two | Column Three |
|:---------- | ---------- |:------------:|
| Row `1`    | Column `2` |              |
| *Row* 2    | **Row** 2  | Column ``3`` |
```

!!! note
    上記の例に示されているように、`|` 文字の各列は垂直に整列する必要があります。

    カラムのヘッダーセパレーターの両端に `:` 文字があると、その行が左揃え、右揃え、または（両端に `:` がある場合）中央揃えであることを指定します。 `:` 文字がない場合は、カラムは右揃えにデフォルト設定されます。


### Admonitions

特別にフォーマットされたブロックは、注意喚起として知られ、特定の発言を強調するために使用できます。これらは次の `!!!` 構文を使用して定義できます：

```
!!! note

    This is the content of the note.
    It is indented by 4 spaces. A tab would work as well.

!!! warning "Beware!"

    And this is another one.

    This warning admonition has a custom title: `"Beware!"`.
```

`!!!`の後の最初の単語は、注意喚起のタイプを宣言します。特別なスタイリングを生成すべき標準的な注意喚起のタイプがあります。すなわち（深刻度の降順で）：`danger`、`warning`、`info`/`note`、および`tip`です。

独自の注意書きタイプを使用することもできますが、タイプ名は小文字のラテン文字（a-z）のみを含む必要があります。たとえば、次のような `terminology` ブロックを作成できます。

```
!!! terminology "julia vs Julia"

    Strictly speaking, "Julia" refers to the language,
    and "julia" to the standard implementation.
```

ただし、Markdownをレンダリングするコードがその特定の注意書きタイプを特別扱いしない限り、デフォルトのスタイルが適用されます。

ボックスのカスタムタイトルは、注意喚起のタイプの後に文字列（ダブルクォーテーションで囲まれた）として提供できます。注意喚起のタイプの後にタイトルテキストが指定されていない場合は、タイプ名がタイトルとして使用されます（例：`note` 注意喚起の場合は `"Note"`）。

注意事項は、他のほとんどのトップレベル要素と同様に、他のトップレベル要素（例：リスト、画像）を含むことができます。

## [Markdown String Literals](@id stdlib-markdown-literals)

`md""` マクロを使用すると、Markdown 文字列を直接 Julia コードに埋め込むことができます。このマクロは、Julia ソースファイル内に Markdown 形式のテキストを簡単に含めるために設計されています。

### Usage

```julia
result = md"This is a **custom** Markdown string with [a link](http://example.com)."
```

## Markdown Syntax Extensions

JuliaのMarkdownは、基本的な文字列リテラルと非常に似た方法で補間をサポートしていますが、オブジェクト自体をMarkdownツリーに保存するという違いがあります（文字列に変換するのではなく）。Markdownコンテンツがレンダリングされると、通常の`show`メソッドが呼び出され、これらは通常通りオーバーライドできます。この設計により、基本的な構文を煩雑にすることなく、参照のような任意に複雑な機能でMarkdownを拡張することが可能になります。

原則として、Markdownパーサー自体はパッケージによって任意に拡張することもでき、または完全にカスタムのMarkdownフレーバーを使用することもできますが、一般的にはこれは不要です。

## [API reference](@id stdlib-markdown-api)

```@docs
Markdown.MD
Markdown.@md_str
Markdown.@doc_str
Markdown.parse
Markdown.html
Markdown.latex
```
