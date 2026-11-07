# [StyledStrings](@id stdlib-styledstrings)

```@meta
CurrentModule = StyledStrings
DocTestSetup = quote
    using StyledStrings
end
```

!!! note
    StyledStrings と AnnotatedStrings の API は実験的なものとみなされており、Julia のバージョン間で変更される可能性があります。


## [Styling](@id stdlib-styledstrings-styling)

文字列を扱う際、書式設定やスタイル設定は二次的な関心事になりがちです。

たとえば、ターミナルに出力するときは、出力に [ANSI escape sequences](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters) を散りばめたいことがあるでしょう。HTML を出力する場合は、`<span style="...">` などのスタイル指定が同様の役割を果たします。スタイル指定をコンテンツの隣にそのまま文字列として挿入することもできますが、すぐに、最も基本的な用途以外には適さないことがわかります。すべてのターミナルが同じ ANSI コードに対応しているわけではありません。また、すでにスタイルが適用されたコンテンツの幅を計算するには、スタイル指定を丹念に取り除く必要があります。さらに、複数の出力形式を扱うとなると、問題は一層複雑になります。

こうした厄介事を下流の利用者に広く押しつけるのではなく、専用の文字列型 [`AnnotatedString`](@ref Base.AnnotatedString) を導入して、正面から解決します。この文字列型は任意の [`AbstractString`](@ref) 型をラップし、領域ごとに書式情報を適用できます（たとえば、1 文字目から 7 文字目までを太字かつ赤色にするなど）。

文字列の領域にスタイルを適用するには、[`Face`](@ref StyledStrings.Face)（「書体」と考えてください）を使います。これはスタイル情報を保持する構造体です。便利なことに、`shadow` など、グローバルな faces 辞書に登録されている face は、[`Face`](@ref StyledStrings.Face) を直接指定する代わりに名前で指定できます。

こうした機能に加えて、[`AnnotatedString`](@ref Base.AnnotatedString) を簡単に構築する方法も用意されています。詳しくは [Styled String Literals](@ref stdlib-styledstring-literals) を参照してください。

```@repl demo
using StyledStrings
styled"{yellow:hello} {blue:there}"
```

## [Annotated Strings](@id man-annotated-strings)

文字列の領域に関連するメタデータを保持できると便利な場合があります。[`AnnotatedString`](@ref Base.AnnotatedString) は別の文字列をラップし、その領域にラベル付きの値（`:label => value`）を注釈として付与できます。一般的な文字列操作はすべて、ラップされた文字列に対して行われます。ただし、可能な場合はスタイル情報が保持されます。そのため、[`AnnotatedString`](@ref Base.AnnotatedString) に対して部分文字列の取得、パディング、他の文字列との連結などの操作を行っても、メタデータ注釈はそのまま引き継がれます。

この文字列型は [StyledStrings stdlib](@ref stdlib-styledstrings) の基盤となっており、`:face` というラベルの注釈を使ってスタイル情報を保持します。

[`AnnotatedString`](@ref Base.AnnotatedString) を連結する際、文字列の注釈を保持したい場合は、[`string`](@ref) ではなく [`annotatedstring`](@ref StyledStrings.annotatedstring) を使ってください。

```jldoctest
julia> str = AnnotatedString("hello there", [(1:5, :word, :greeting), (7:11, :label, 1)])
"hello there"

julia> length(str)
11

julia> lpad(str, 14)
"   hello there"

julia> typeof(lpad(str, 7))
AnnotatedString{String}

julia> str2 = AnnotatedString(" julia", [(2:6, :face, :magenta)])
" julia"

julia> annotatedstring(str, str2)
"hello there julia"

julia> str * str2 == annotatedstring(str, str2) # *-concatenation works
true
```

[`AnnotatedString`](@ref Base.AnnotatedString) の注釈は、[`annotations`](@ref StyledStrings.annotations) 関数と [`annotate!`](@ref StyledStrings.annotate!) 関数を使って取得・変更できます。

## Styling via [`AnnotatedString`](@ref Base.AnnotatedString)s

## [Faces](@id stdlib-styledstrings-faces)

### The `Face` type

[`Face`](@ref StyledStrings.Face) は、テキストに適用できる書体の詳細を指定します。さまざまな形式に広く適用できる基本属性を備えており、具体的には次のとおりです。

  * `font`
  * `height`
  * `weight`
  * `slant`
  * `foreground`
  * `background`
  * `underline`
  * `strikethrough`
  * `inverse`
  * `inherit`

これらの属性が具体的にどのような形式を取るかについては、[`Face`](@ref StyledStrings.Face) の docstring を参照してください。特に注目すべきなのは `inherit` です。これを使うと、他の [`Face`](@ref StyledStrings.Face) から属性を*継承*できます。

### The global faces dictionary

特定のスタイルを簡単に参照できるよう、グローバルな `Dict{Symbol, Face}` が用意されています。これにより、[`Face`](@ref StyledStrings.Face) を名前だけで参照できます。パッケージは [`addface!`](@ref StyledStrings.addface!) 関数を使ってこの辞書に face を追加でき、読み込まれた face は簡単に [customized](@ref stdlib-styledstrings-face-toml) できます。

!!! warning "face の適切な命名"
    新しい face を登録するパッケージは、パッケージ名を接頭辞として付け、`mypackage_myface` の形式に従う必要があります。これは予測可能性を高め、名前の衝突を防ぐために重要です。

    また、パッケージでは、直接的な色やスタイル（`cyan` など）よりも、意味に基づく face（`code` など）を使用し、導入するようにしてください。これにより、使用時の意図が明確になり、組み合わせやすくなるほか、ユーザーによるカスタマイズも直感的になります。


パッケージ名を接頭辞に付ける規則には、次の 2 つの例外があります。

  * faces 辞書のデフォルト値に含まれる基本 face
  * Julia 自身の標準ライブラリが導入する face、すなわち `JuliaSyntaxHighlighting`

#### [Basic faces](@id stdlib-styledstrings-basic-faces)

基本 face は、幅広く適用できる一般的な概念を表すことを目的としています。

特定の属性をテキストに設定するために、`bold`、`light`、`italic`、`underline`、`strikethrough`、`inverse` の各 face が用意されています。

また、ターミナルの 16 色には、名前付き face があります。`black`、`red`、`green`、`yellow`、`blue`、`magenta`、`cyan`、`white`、`bright_black`/`grey`/`gray`、`bright_red`、`bright_green`、`bright_blue`、`bright_magenta`、`bright_cyan`、`bright_white` です。

影付きのテキスト（薄く表示されるもの）には `shadow` face が用意されています。選択範囲を示すには `region` face を使います。同様に、強調とハイライトには `emphasis` face と `highlight` face が定義されています。また、コード風のテキストには `code` が用意されています。

メッセージの重大度を視覚的に示すため、`error`、`warning`、`success`、`info`、`note`、`tip` の各 face が定義されています。

### [Customisation of faces (`Faces.toml`)](@id stdlib-styledstrings-face-toml)

グローバルな face 辞書にある名前付き face は、カスタマイズできると便利です。テーマや見た目を調整できるだけでなく、アクセシビリティの面でも重要です。TOML ファイルを解析して [`Face`](@ref StyledStrings.Face) 仕様のリストに変換し、face 辞書の既存のエントリとマージできます。

[`Face`](@ref StyledStrings.Face) は、TOML では次のように表されます。

```toml
[facename]
attribute = "value"
...

[package.facename]
attribute = "value"
```

たとえば、`shadow` face が読みにくい場合は、次のように明るくできます。

```toml
[shadow]
foreground = "white"
```

初期化時に、最初の Julia depot（通常は `~/.julia`）にある `config/faces.toml` ファイルが読み込まれます。

### Applying faces to a `AnnotatedString`

慣例として、[`AnnotatedString`](@ref Base.AnnotatedString) の `:face` 属性には、現在適用されている [`Face`](@ref StyledStrings.Face) の情報を格納します。指定方法はいくつかあり、グローバルな face 辞書にある [`Face`](@ref StyledStrings.Face) を名前で指定する単一の `Symbol`、[`Face`](@ref StyledStrings.Face) 自体、またはそのいずれかを要素とするベクターを使えます。

`show(::IO, ::MIME"text/plain", ::AnnotatedString)` メソッドと `show(::IO, ::MIME"text/html", ::AnnotatedString)` メソッドは、どちらも `:face` 属性を参照し、全体のスタイルを決定する際にそれらをすべてマージします。

`:face` 属性は、構築時に `AnnotatedString` に渡すことも、後からプロパティのリストに追加することもできます。また、便利な [Styled String literals](@ref stdlib-styledstring-literals) を使う方法もあります。

```@repl demo
str1 = AnnotatedString("blue text", [(1:9, :face, :blue)])
str2 = styled"{blue:blue text}"
str1 == str2
sprint(print, str1, context = :color => true)
sprint(show, MIME("text/html"), str1, context = :color => true)
```

## [Styled String Literals](@id stdlib-styledstring-literals)

[`AnnotatedString`](@ref Base.AnnotatedString) に [`Face`](@ref StyledStrings.Face) を適用した文字列を簡単に構築できるよう、[`styled"..."`](@ref @styled_str) というスタイル付き文字列リテラルが用意されています。独自の文法を使って、内容と属性をまとめて記述できます。

[`styled"..."`](@ref @styled_str) リテラルでは、中括弧は特殊文字として扱われるため、通常の用途で使う場合はエスケープする必要があります（`\{`、`\}`）。これにより、中括弧を使って `{annotations...:text}` 構文による注釈（入れ子にもできます）を記述できます。

`annotations...` の部分は、次の 3 種類の注釈をカンマで区切ったリストです。

  * face 名
  * インライン `Face` 式 `(key=val,...)`
  * `key=value` のペア

インライン face キーを除き、どこでも補間を使えます。

文法の詳細については、[`styled"..."`](@ref @styled_str) の docstring にある拡張ヘルプを参照してください。

例として、前述の組み込み face の一覧を次のように示します。

```julia-repl
julia> println(styled"
The basic font-style attributes are {bold:bold}, {light:light}, {italic:italic},
{underline:underline}, and {strikethrough:strikethrough}.

In terms of color, we have named faces for the 16 standard terminal colors:
 {black:■} {red:■} {green:■} {yellow:■} {blue:■} {magenta:■} {cyan:■} {white:■}
 {bright_black:■} {bright_red:■} {bright_green:■} {bright_yellow:■} {bright_blue:■} {bright_magenta:■} {bright_cyan:■} {bright_white:■}

Since {code:bright_black} is effectively grey, we define two aliases for it:
{code:grey} and {code:gray} to allow for regional spelling differences.

To flip the foreground and background colors of some text, you can use the
{code:inverse} face, for example: {magenta:some {inverse:inverse} text}.

The intent-based basic faces are {shadow:shadow} (for dim but visible text),
{region:region} for selections, {emphasis:emphasis}, and {highlight:highlight}.
As above, {code:code} is used for code-like text.

Lastly, we have the 'message severity' faces: {error:error}, {warning:warning},
{success:success}, {info:info}, {note:note}, and {tip:tip}.

Remember that all these faces (and any user or package-defined ones) can
arbitrarily nest and overlap, {region,tip:like {bold,italic:so}}.")
```

```@raw comment
Documenter doesn't properly represent all the styling above, so I've converted it manually to HTML and LaTeX.
```

```@raw html
<pre>
 The basic font-style attributes are <span style="font-weight: 700;">bold</span>, <span style="font-weight: 300;">light</span>, <span style="font-style: italic;">italic</span>,
 <span style="text-decoration: underline;">underline</span>, and <span style="text-decoration: line-through">strikethrough</span>.

 In terms of color, we have named faces for the 16 standard terminal colors:
  <span style="color: #1c1a23;">■</span> <span style="color: #a51c2c;">■</span> <span style="color: #25a268;">■</span> <span style="color: #e5a509;">■</span> <span style="color: #195eb3;">■</span> <span style="color: #803d9b;">■</span> <span style="color: #0097a7;">■</span> <span style="color: #dddcd9;">■</span>
  <span style="color: #76757a;">■</span> <span style="color: #ed333b;">■</span> <span style="color: #33d079;">■</span> <span style="color: #f6d22c;">■</span> <span style="color: #3583e4;">■</span> <span style="color: #bf60ca;">■</span> <span style="color: #26c6da;">■</span> <span style="color: #f6f5f4;">■</span>

 Since <span style="color: #0097a7;">bright_black</span> is effectively grey, we define two aliases for it:
 <span style="color: #0097a7;">grey</span> and <span style="color: #0097a7;">gray</span> to allow for regional spelling differences.

 To flip the foreground and background colors of some text, you can use the
 <span style="color: #0097a7;">inverse</span> face, for example: <span style="color: #803d9b;">some </span><span style="background-color: #803d9b;">inverse</span><span style="color: #803d9b;"> text</span>.

 The intent-based basic faces are <span style="color: #76757a;">shadow</span> (for dim but visible text),
 <span style="background-color: #3a3a3a;">region</span> for selections, <span style="color: #195eb3;">emphasis</span>, and <span style="background-color: #195eb3;">highlight</span>.
 As above, <span style="color: #0097a7;">code</span> is used for code-like text.

 Lastly, we have the 'message severity' faces: <span style="color: #ed333b;">error</span>, <span style="color: #e5a509;">warning</span>,
 <span style="color: #25a268;">success</span>, <span style="color: #26c6da;">info</span>, <span style="color: #76757a;">note</span>, and <span style="color: #33d079;">tip</span>.

 Remember that all these faces (and any user or package-defined ones) can
 arbitrarily nest and overlap, <span style="color: #33d079;background-color: #3a3a3a;">like <span style="font-weight: 700;font-style: italic;">so</span></span>.</pre>
```

```@raw latex
\begingroup
\ttfamily
\setlength{\parindent}{0pt}
\setlength{\parskip}{\baselineskip}

The basic font-style attributes are {\fontseries{b}\selectfont bold}, {\fontseries{l}\selectfont light}, {\fontshape{it}\selectfont italic},\\
\underline{underline}, and {strikethrough}.

In terms of color, we have named faces for the 16 standard terminal colors:\\
{\color[HTML]{1c1a23}\(\blacksquare\)} {\color[HTML]{a51c2c}\(\blacksquare\)} {\color[HTML]{25a268}\(\blacksquare\)}
{\color[HTML]{e5a509}\(\blacksquare\)} {\color[HTML]{195eb3}\(\blacksquare\)} {\color[HTML]{803d9b}\(\blacksquare\)}
{\color[HTML]{0097a7}\(\blacksquare\)} {\color[HTML]{dddcd9}\(\blacksquare\)} \\
{\color[HTML]{76757a}\(\blacksquare\)} {\color[HTML]{ed333b}\(\blacksquare\)} {\color[HTML]{33d079}\(\blacksquare\)} {\color[HTML]{f6d22c}\(\blacksquare\)} {\color[HTML]{3583e4}\(\blacksquare\)} {\color[HTML]{bf60ca}\(\blacksquare\)} {\color[HTML]{26c6da}\(\blacksquare\)} {\color[HTML]{f6f5f4}\(\blacksquare\)}

Since {\color[HTML]{0097a7}bright\_black} is effectively grey, we define two aliases for it:\\
{\color[HTML]{0097a7}grey} and {\color[HTML]{0097a7}gray} to allow for regional spelling differences.

To flip the foreground and background colors of some text, you can use the\\
{\color[HTML]{0097a7}inverse} face, for example: {\color[HTML]{803d9b}some \colorbox[HTML]{803d9b}{\color[HTML]{000000}inverse} text}.

The intent-based basic faces are {\color[HTML]{76757a}shadow} (for dim but visible text),\\
\colorbox[HTML]{3a3a3a}{region} for selections, {\color[HTML]{195eb3}emphasis}, and \colorbox[HTML]{195eb3}{highlight}.\\
As above, {\color[HTML]{0097a7}code} is used for code-like text.

Lastly, we have the 'message severity' faces: {\color[HTML]{ed333b}error}, {\color[HTML]{e5a509}warning},\\
{\color[HTML]{25a268}success}, {\color[HTML]{26c6da}info}, {\color[HTML]{76757a}note}, and {\color[HTML]{33d079}tip}.

Remember that all these faces (and any user or package-defined ones) can\\
arbitrarily nest and overlap, \colorbox[HTML]{3a3a3a}{\color[HTML]{33d079}like
  {\fontseries{b}\fontshape{it}\selectfont so}}.
\endgroup
```

## [API reference](@id stdlib-styledstrings-api)

### Styling and Faces

```@docs
StyledStrings.@styled_str
StyledStrings.styled
StyledStrings.Face
StyledStrings.addface!
StyledStrings.withfaces
StyledStrings.SimpleColor
StyledStrings.parse(::Type{StyledStrings.SimpleColor}, ::String)
StyledStrings.tryparse(::Type{StyledStrings.SimpleColor}, ::String)
StyledStrings.merge(::StyledStrings.Face, ::StyledStrings.Face)
```
