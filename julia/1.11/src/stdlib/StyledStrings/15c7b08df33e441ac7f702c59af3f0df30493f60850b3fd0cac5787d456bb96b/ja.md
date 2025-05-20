# [StyledStrings](@id stdlib-styledstrings)

```@meta
CurrentModule = StyledStrings
DocTestSetup = quote
    using StyledStrings
end
```

!!! note
    StyledStrings と AnnotatedStrings の API は実験的と見なされており、Julia のバージョン間で変更される可能性があります。


## [Styling](@id stdlib-styledstrings-styling)

文字列を扱う際、フォーマットやスタイルはしばしば二次的な関心事として現れます。

例えば、ターミナルに出力する際に、出力に [ANSI escape sequences](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters) を散りばめたい場合、HTMLスタイリング構造（`<span style="...">` など）も同様の目的を果たします。このように、コンテンツ自体の隣に生のスタイリング構造を単純に挿入することは可能ですが、これは最も基本的なユースケースにしか適していないことがすぐに明らかになります。すべてのターミナルが同じANSIコードをサポートしているわけではなく、スタイリング構造はすでにスタイルが適用されたコンテンツの幅を計算する際に手間をかけて削除する必要がありますし、複数の出力形式を扱う前にそれが必要です。

この頭痛を下流で広く経験されるのを避けるために、特別な文字列型（[`AnnotatedString`](@ref Base.AnnotatedString)）が導入され、直接対処されます。この文字列型は、他の[`AbstractString`](@ref)型をラップし、特定の領域にフォーマット情報を適用できるようにします（例：文字1から7は太字で赤色です）。

文字列の領域は、[`Face`](@ref StyledStrings.Face)（「フォント」と考えてください）を適用することでスタイルが設定されます。これはスタイリング情報を保持する構造です。便利なことに、グローバルフェイス辞書内のフェイス（例：`shadow`）は、`4d61726b646f776e2e436f64652822222c2022466163652229_40726566205374796c6564537472696e67732e46616365`を直接指定する代わりに名前を付けることができます。

これらの機能に加えて、[`AnnotatedString`](@ref Base.AnnotatedString)を構築するための便利な方法も提供しています。詳細は[Styled String Literals](@ref stdlib-styledstring-literals)に記載されています。

```@repl demo
using StyledStrings
styled"{yellow:hello} {blue:there}"
```

## [Annotated Strings](@id man-annotated-strings)

文字列の領域に関連するメタデータを保持することができると、時には便利です。[`AnnotatedString`](@ref Base.AnnotatedString)は別の文字列をラップし、その一部にラベル付きの値（`:label => value`）で注釈を付けることを可能にします。すべての一般的な文字列操作は、基になる文字列に適用されます。ただし、可能な場合はスタイリング情報が保持されます。これは、`4d61726b646f776e2e436f64652822222c2022416e6e6f7461746564537472696e672229_4072656620426173652e416e6e6f7461746564537472696e67`を操作することができることを意味します—部分文字列を取り出したり、パディングを追加したり、他の文字列と連結したりしても、メタデータの注釈は「一緒に付いてくる」のです。

この文字列タイプは、スタイリング情報を保持するために `:face` ラベル付きの注釈を使用する [StyledStrings stdlib](@ref stdlib-styledstrings) にとって基本的です。

When concatenating a [`AnnotatedString`](@ref Base.AnnotatedString), take care to use [`annotatedstring`](@ref StyledStrings.annotatedstring) instead of [`string`](@ref) if you want to keep the string annotations.

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

[`AnnotatedString`](@ref Base.AnnotatedString) のアノテーションは、[`annotations`](@ref StyledStrings.annotations) および [`annotate!`](@ref StyledStrings.annotate!) 関数を介してアクセスおよび変更できます。

## Styling via [`AnnotatedString`](@ref Base.AnnotatedString)s

## [Faces](@id stdlib-styledstrings-faces)

### The `Face` type

[`Face`](@ref StyledStrings.Face) は、テキストを設定できるフォントの詳細を指定します。これは、異なるフォーマット全体で一般化される基本的な属性のセットをカバーしています。すなわち：

  * `フォント`
  * `高さ`
  * `体重`
  * `スラント`
  * `前景`
  * `背景`
  * `アンダーライン`
  * `取り消し線`
  * `逆`
  * `継承`

特定の属性がどのような形を取るかの詳細については、[`Face`](@ref StyledStrings.Face) ドキュメンテーションを参照してくださいが、特に興味深いのは `inherit` であり、これにより他の `4d61726b646f776e2e436f64652822222c2022466163652229_40726566205374796c6564537472696e67732e46616365` から属性を *継承* することができます。

### The global faces dictionary

特定のスタイルを参照するのを便利にするために、グローバルな `Dict{Symbol, Face}` があり、これにより [`Face`](@ref StyledStrings.Face) を単に名前で参照することができます。パッケージは [`addface!`](@ref StyledStrings.addface!) 関数を介してこの辞書にフェイスを追加でき、読み込まれたフェイスは簡単に [customized](@ref stdlib-styledstrings-face-toml) できます。

!!! warning "Appropriate face naming"
    新しいフェイスを登録するパッケージは、パッケージ名でプレフィックスを付ける必要があります。つまり、フォーマット `mypackage_myface` に従う必要があります。これは予測可能性のため、また名前の衝突を防ぐために重要です。

    さらに、パッケージは直接的な色やスタイル（例えば `cyan`）の代わりに、*セマンティック*なフェイス（例えば `code`）を使用（および導入）するように注意すべきです。これは、使用意図をより明確にし、コンポーザビリティを助け、ユーザーのカスタマイズをより直感的にするなど、いくつかの点で役立ちます。


パッケージ接頭辞ルールには2つの免除があります：

  * デフォルト値のフェイス辞書に含まれる基本的なフェイスのセット
  * Juliaの標準ライブラリである`JuliaSyntaxHighlighting`によって導入された顔。

#### [Basic faces](@id stdlib-styledstrings-basic-faces)

基本的な顔は、広く適用可能な一般的なアイデアを表すことを意図しています。

特定の属性を持つテキストを設定するために、`bold`、`light`、`italic`、`underline`、`strikethrough`、および `inverse` フェイスがあります。

16の端末色には、次のような名前付きの色もあります: `black`、`red`、`green`、`yellow`、`blue`、`magenta`、`cyan`、`white`、`bright_black`/`grey`/`gray`、`bright_red`、`bright_green`、`bright_blue`、`bright_magenta`、`bright_cyan`、および `bright_white`。

影のあるテキスト（つまり、薄いが存在するもの）には `shadow` フェイスがあります。選択された領域を示すためには `region` フェイスがあります。同様に、強調やハイライトのために `emphasis` と `highlight` フェイスが定義されています。また、コードのようなテキストには `code` があります。

メッセージの重大性を視覚的に示すために、`error`、`warning`、`success`、`info`、`note`、および `tip` のフェイスが定義されています。

### [Customisation of faces (`Faces.toml`)](@id stdlib-styledstrings-face-toml)

グローバルフェイス辞書の名前の顔がカスタマイズ可能であることは良いことです。テーマや美学は素晴らしく、アクセシビリティの理由からも重要です。TOMLファイルは、フェイス辞書の既存のエントリとマージされる[`Face`](@ref StyledStrings.Face)仕様のリストに解析できます。

[`Face`](@ref StyledStrings.Face) は、TOML では次のように表現されます：

```toml
[facename]
attribute = "value"
...

[package.facename]
attribute = "value"
```

例えば、`shadow` フェイスが読みづらい場合は、次のように明るくすることができます：

```toml
[shadow]
foreground = "white"
```

初期化時に、最初のJuliaデポ（通常は`~/.julia`）の下にある`config/faces.toml`ファイルが読み込まれます。

### Applying faces to a `AnnotatedString`

慣例として、[`AnnotatedString`](@ref Base.AnnotatedString)の`:face`属性は、現在適用されている[`Face`](@ref StyledStrings.Face)に関する情報を保持します。これは、グローバルフェイス辞書内の`4d61726b646f776e2e436f64652822222c2022466163652229_40726566205374796c6564537472696e67732e46616365`を名前付けする単一の`Symbol`、`4d61726b646f776e2e436f64652822222c2022466163652229_40726566205374796c6564537472696e67732e46616365`自体、またはそのいずれかのベクトルの形で提供できます。

`show(::IO, ::MIME"text/plain", ::AnnotatedString)` および `show(::IO, ::MIME"text/html", ::AnnotatedString)` メソッドはどちらも `:face` 属性を確認し、全体のスタイリングを決定する際にそれらをすべて統合します。

`AnnotatedString`の構築時に`:face`属性を供給することができ、その後プロパティリストに追加するか、便利な[Styled String literals](@ref stdlib-styledstring-literals)を使用します。

```@repl demo
str1 = AnnotatedString("blue text", [(1:9, :face, :blue)])
str2 = styled"{blue:blue text}"
str1 == str2
sprint(print, str1, context = :color => true)
sprint(show, MIME("text/html"), str1, context = :color => true)
```

## [Styled String Literals](@id stdlib-styledstring-literals)

[`AnnotatedString`](@ref Base.AnnotatedString)の構築を容易にするために、[`Face`](@ref StyledStrings.Face)が適用され、[`styled"..."`](@ref @styled_str)スタイルの文字列リテラルは、コンテンツと属性をカスタム文法を介して簡単に表現できるようにします。

[`styled"..."`](@ref @styled_str) リテラル内では、波括弧は特別な文字と見なされ、通常の使用ではエスケープする必要があります（`\{`、`\}`）。これにより、（ネスト可能な）`{annotations...:text}` 構造を使用して注釈を表現することができます。

`annotations...` コンポーネントは、3種類のアノテーションのカンマ区切りリストです。

  * 顔の名前
  * インライン `Face` 表現 `(key=val,...)`
  * `key=value` ペア

補間はインラインフェイスキーを除いて、どこでも可能です。

詳細な文法については、[`styled"..."`](@ref @styled_str) ドキュメントの拡張ヘルプを参照してください。

上記で言及された組み込みの顔のリストを次のように示すことができます：

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
