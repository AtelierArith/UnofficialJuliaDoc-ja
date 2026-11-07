# [Strings](@id man-strings)

文字列は、文字の有限列です。もちろん、本当に難しいのは、そもそも文字とは何かという問題です。英語話者になじみのある文字には、`A`、`B`、`C` などの英字、数字、一般的な句読点や記号があります。これらの文字は、0 から 127 までの整数値への対応付けとともに、[ASCII](https://en.wikipedia.org/wiki/ASCII) 規格で標準化されています。当然ながら、英語以外の言語ではほかにも多くの文字が使われています。たとえば、ASCII 文字にアクセントなどの変更を加えたもの、キリル文字やギリシャ文字のような関連する文字体系、さらにアラビア語、中国語、ヘブライ語、ヒンディー語、日本語、韓国語など、ASCII や英語とはまったく異なる文字体系があります。[Unicode](https://en.wikipedia.org/wiki/Unicode) 規格は、文字とは正確には何かという複雑な問題に取り組んでおり、この問題に関する決定的な標準として広く受け入れられています。必要に応じて、この複雑さを完全に無視して ASCII 文字だけが存在するものとして扱うことも、非 ASCII テキストを扱う際に遭遇しうるあらゆる文字やエンコーディングに対応するコードを書くこともできます。Julia では、単純な ASCII テキストを簡単かつ効率的に扱えます。また、Unicode の処理も可能な限り簡単かつ効率的になっています。特に、ASCII 文字列を処理する C スタイルの文字列コードを書くことができ、そのコードは性能面でも意味の面でも期待どおりに動作します。そのようなコードが非 ASCII テキストに遭遇した場合、気付かないうちに誤った結果を生むのではなく、明確なエラーメッセージを出して安全に失敗します。その場合も、非 ASCII データを扱えるようにコードを修正するのは簡単です。

Julia の文字列には、概要として注目すべき特徴がいくつかあります。

  * Julia で文字列（および文字列リテラル）に使われる組み込みの具象型は [`String`](@ref) です。この型は、[UTF-8](https://en.wikipedia.org/wiki/UTF-8) エンコーディングによって、[Unicode](https://en.wikipedia.org/wiki/Unicode) のすべての文字をサポートします。（ほかの Unicode エンコーディングとの相互変換には、[`transcode`](@ref) 関数が用意されています。）
  * すべての文字列型は抽象型 `AbstractString` のサブタイプです。外部パッケージでは、たとえばほかのエンコーディングに対応するために、`AbstractString` のサブタイプを追加で定義しています。文字列を引数に取る関数を定義する場合は、あらゆる文字列型を受け入れられるように、引数の型を `AbstractString` と宣言してください。
  * C や Java と同様に、ただしほとんどの動的言語とは異なり、Julia には単一の文字を表す第一級の型 [`AbstractChar`](@ref) があります。`AbstractChar` の組み込みサブタイプである [`Char`](@ref) は、任意の Unicode 文字を表現できる 32 ビットのプリミティブ型で、UTF-8 エンコーディングに基づいています。
  * Java と同様に、文字列はイミュータブルです。`AbstractString` オブジェクトの値は変更できません。異なる文字列値を作るには、ほかの文字列の一部を組み合わせて新しい文字列を作成します。
  * 概念的には、文字列はインデックスから文字への*部分関数*です。インデックスの値によっては文字値が返されず、代わりに例外が送出されます。これにより、文字単位のインデックスではなく、エンコードされた表現のバイトインデックスを使って効率的に文字列にアクセスできます。Unicode 文字列の可変幅エンコーディングでは、文字単位のインデックスによるアクセスを効率的かつ単純に実装することはできません。

## [Characters](@id man-characters)

`Char` の値は単一の文字を表します。この型自体は、特別なリテラル表現と適切な算術演算の動作を備えた 32 ビットのプリミティブ型にすぎず、[Unicode code point](https://en.wikipedia.org/wiki/Code_point) を表す数値に変換できます。（Julia のパッケージでは、たとえばほかの [text encodings](https://en.wikipedia.org/wiki/Character_encoding) に対する操作を最適化するために、`AbstractChar` の別のサブタイプを定義することもできます。）`Char` の値は、次のように入力・表示されます（文字リテラルはダブルクォートではなくシングルクォートで囲むことに注意してください）。

```jldoctest
julia> c = 'x'
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)

julia> typeof(c)
Char
```

`Char` は、対応する整数値、つまりコードポイントに簡単に変換できます。

```jldoctest
julia> c = Int('x')
120

julia> typeof(c)
Int64
```

32 ビットアーキテクチャでは、[`typeof(c)`](@ref) は [`Int32`](@ref) になります。整数値を `Char` に戻すのも同じように簡単です。

```jldoctest
julia> Char(120)
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)
```

すべての整数値が有効な Unicode コードポイントであるわけではありませんが、性能上の理由から、`Char` への変換では各文字値が有効かどうかを検査しません。変換した各値が有効なコードポイントであることを確認したい場合は、[`isvalid`](@ref) 関数を使ってください。

```jldoctest
julia> Char(0x110000)
'\U110000': Unicode U+110000 (category In: Invalid, too high)

julia> isvalid(Char, 0x110000)
false
```

執筆時点で有効な Unicode コードポイントは、`U+0000` から `U+D7FF`、および `U+E000` から `U+10FFFF` です。これらすべてに意味が割り当てられているわけではなく、必ずしもアプリケーションで解釈できるわけでもありませんが、これらの値はすべて有効な Unicode 文字とみなされます。

シングルクォートの中で、`\u` に続けて最大 4 桁の 16 進数、または `\U` に続けて最大 8 桁の 16 進数を指定すると、任意の Unicode 文字を入力できます（有効な値のうち最も長いものでも、必要なのは 6 桁だけです）。

```jldoctest
julia> '\u0'
'\0': ASCII/Unicode U+0000 (category Cc: Other, control)

julia> '\u78'
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)

julia> '\u2200'
'∀': Unicode U+2200 (category Sm: Symbol, math)

julia> '\U10ffff'
'\U10ffff': Unicode U+10FFFF (category Cn: Other, not assigned)
```

Julia はシステムのロケールと言語の設定を使って、どの文字をそのまま表示でき、どの文字を汎用的なエスケープ形式 `\u` または `\U` で出力する必要があるかを判断します。これらの Unicode エスケープ形式に加えて、[C's traditional escaped input forms](https://en.wikipedia.org/wiki/C_syntax#Backslash_escapes) もすべて使用できます。

```jldoctest
julia> Int('\0')
0

julia> Int('\t')
9

julia> Int('\n')
10

julia> Int('\e')
27

julia> Int('\x7f')
127

julia> Int('\177')
127
```

`Char` の値に対しては、比較と一部の算術演算が可能です。

```jldoctest
julia> 'A' < 'a'
true

julia> 'A' <= 'a' <= 'Z'
false

julia> 'A' <= 'X' <= 'Z'
true

julia> 'x' - 'a'
23

julia> 'A' + 1
'B': ASCII/Unicode U+0042 (category Lu: Letter, uppercase)
```

## String Basics

文字列リテラルは、ダブルクォートまたは三重のダブルクォートで囲みます（シングルクォートではありません）。

```jldoctest helloworldstring
julia> str = "Hello, world.\n"
"Hello, world.\n"

julia> """Contains "quote" characters"""
"Contains \"quote\" characters"
```

文字列内の長い行は、改行の直前にバックスラッシュ（`\`）を置くことで分割できます。

```jldoctest
julia> "This is a long \
       line"
"This is a long line"
```

文字列から文字を取り出すには、インデックスを指定します。

```jldoctest helloworldstring
julia> str[begin]
'H': ASCII/Unicode U+0048 (category Lu: Letter, uppercase)

julia> str[1]
'H': ASCII/Unicode U+0048 (category Lu: Letter, uppercase)

julia> str[6]
',': ASCII/Unicode U+002C (category Po: Punctuation, other)

julia> str[end]
'\n': ASCII/Unicode U+000A (category Cc: Other, control)
```

文字列を含む多くの Julia オブジェクトでは、整数によるインデックスアクセスが可能です。最初の要素（文字列の場合は最初の文字）のインデックスは [`firstindex(str)`](@ref) で、最後の要素（文字）のインデックスは [`lastindex(str)`](@ref) で取得できます。インデックス操作の中では、キーワード `begin` と `end` を、指定した次元の最初と最後のインデックスの略記としてそれぞれ使えます。Julia のほとんどのインデックスと同様に、文字列のインデックスは 1 から始まります。どの `AbstractString` に対しても、`firstindex` は常に `1` を返します。ただし後で説明するように、Unicode 文字の中には複数の「コード単位」を占めるものがあるため、文字列では一般に `lastindex(str)` と `length(str)` は*同じではありません*。

[`end`](@ref) に対しては、通常の値と同様に算術演算などの操作を行えます。

```jldoctest helloworldstring
julia> str[end-1]
'.': ASCII/Unicode U+002E (category Po: Punctuation, other)

julia> str[end÷2]
' ': ASCII/Unicode U+0020 (category Zs: Separator, space)
```

`begin`（`1`）より小さいインデックス、または `end` より大きいインデックスを使うと、エラーになります。

```jldoctest helloworldstring
julia> str[begin-1]
ERROR: BoundsError: attempt to access 14-codeunit String at index [0]
[...]

julia> str[end+1]
ERROR: BoundsError: attempt to access 14-codeunit String at index [15]
[...]
```

インデックスに範囲を指定して、部分文字列を取り出すこともできます。

```jldoctest helloworldstring
julia> str[4:9]
"lo, wo"
```

式 `str[k]` と `str[k:k]` は、同じ結果にはならないことに注意してください。

```jldoctest helloworldstring
julia> str[6]
',': ASCII/Unicode U+002C (category Po: Punctuation, other)

julia> str[6:6]
","
```

前者は `Char` 型の単一の文字値であり、後者はたまたま 1 文字だけを含む文字列値です。Julia では、これらはまったく異なるものです。

範囲によるインデックスアクセスでは、元の文字列の選択された部分がコピーされます。代わりに、[`SubString`](@ref) 型を使って文字列のビューを作成することもできます。より簡単な方法として、コードブロックに [`@views`](@ref) マクロを適用すると、すべての文字列スライスを部分文字列に変換できます。たとえば次のようにします。

```jldoctest
julia> str = "long string"
"long string"

julia> substr = SubString(str, 1, 4)
"long"

julia> typeof(substr)
SubString{String}

julia> @views typeof(str[1:4]) # @views converts slices to SubStrings
SubString{String}
```

[`chop`](@ref)、[`chomp`](@ref)、[`strip`](@ref) など、いくつかの標準関数は [`SubString`](@ref) を返します。

## Unicode and UTF-8

Julia は Unicode の文字と文字列を完全にサポートしています。[discussed above](@ref man-characters)、文字リテラルでは、Unicode の `\u` および `\U` エスケープシーケンスを使って Unicode コードポイントを表現でき、C の標準エスケープシーケンスもすべて使えます。これらは文字列リテラルの記述にも同様に使えます。

```jldoctest unicodestring
julia> s = "\u2200 x \u2203 y"
"∀ x ∃ y"
```

これらの Unicode 文字がエスケープ形式で表示されるか、特殊文字として表示されるかは、端末のロケール設定と Unicode のサポート状況によって決まります。文字列リテラルは UTF-8 でエンコードされます。UTF-8 は可変幅エンコーディングであり、すべての文字が同じバイト数（「コード単位」数）でエンコードされるわけではありません。UTF-8 では、ASCII 文字、つまりコードポイントが 0x80（128）未満の文字は、ASCII と同じく 1 バイトでエンコードされます。一方、0x80 以上のコードポイントは、1 文字につき最大 4 バイトの複数バイトでエンコードされます。

Julia の文字列インデックスは、コード単位（UTF-8 ではバイト）を指します。コード単位は、任意の文字（コードポイント）をエンコードするために使われる固定幅の構成単位です。したがって、`String` に対するすべてのインデックスが、文字を指す有効なインデックスとは限りません。このような無効なバイトインデックスで文字列にアクセスすると、エラーが送出されます。

```jldoctest unicodestring
julia> s[1]
'∀': Unicode U+2200 (category Sm: Symbol, math)

julia> s[2]
ERROR: StringIndexError: invalid index [2], valid nearby indices [1]=>'∀', [4]=>' '
Stacktrace:
[...]

julia> s[3]
ERROR: StringIndexError: invalid index [3], valid nearby indices [1]=>'∀', [4]=>' '
Stacktrace:
[...]

julia> s[4]
' ': ASCII/Unicode U+0020 (category Zs: Separator, space)
```

この場合、文字 `∀` は 3 バイトの文字なので、インデックス 2 と 3 は無効であり、次の文字のインデックスは 4 です。この次の有効なインデックスは [`nextind(s,1)`](@ref) で、その次のインデックスは `nextind(s,4)` で、というように計算できます。

`end` は常にコレクション内の最後の有効なインデックスなので、末尾から 2 番目の文字がマルチバイト文字であれば、`end-1` は無効なバイトインデックスを指します。

```jldoctest unicodestring
julia> s[end-1]
' ': ASCII/Unicode U+0020 (category Zs: Separator, space)

julia> s[end-2]
ERROR: StringIndexError: invalid index [9], valid nearby indices [7]=>'∃', [10]=>' '
Stacktrace:
[...]

julia> s[prevind(s, end, 2)]
'∃': Unicode U+2203 (category Sm: Symbol, math)
```

最初の例が動作するのは、最後の文字 `y` と空白が 1 バイトの文字だからです。一方、`end-2` は `∃` のマルチバイト表現の途中を指します。この場合の正しい方法は `prevind(s, lastindex(s), 2)` を使うことです。また、その値を `s` のインデックスとして使うなら、`s[prevind(s, end, 2)]` と書けます。`end` は `lastindex(s)` に展開されます。

範囲による部分文字列の取り出しでも、有効なバイトインデックスを指定する必要があり、そうでなければエラーが送出されます。

```jldoctest unicodestring
julia> s[1:1]
"∀"

julia> s[1:2]
ERROR: StringIndexError: invalid index [2], valid nearby indices [1]=>'∀', [4]=>' '
Stacktrace:
[...]

julia> s[1:4]
"∀ "
```

可変長エンコーディングを使うため、文字列の文字数（[`length(s)`](@ref) で取得）は、必ずしも最後のインデックスと一致しません。1 から [`lastindex(s)`](@ref) までのインデックスを順に使って `s` にアクセスすると、エラーが送出されなかったときに返される文字の列は、文字列 `s` を構成する文字の列になります。文字列の各文字にはそれぞれ固有のインデックスが必要なので、`length(s) <= lastindex(s)` が成り立ちます。次は、`s` の各文字を反復処理する、非効率的で冗長な方法です。

```jldoctest unicodestring
julia> for i = firstindex(s):lastindex(s)
           try
               println(s[i])
           catch
               # ignore the index error
           end
       end
∀

x

∃

y
```

空行に見える行には、実際には空白が入っています。幸い、文字列の各文字を反復処理するのに、このような扱いにくい書き方は必要ありません。文字列をそのまま反復可能なオブジェクトとして使えばよく、例外処理は不要です。

```jldoctest unicodestring
julia> for c in s
           println(c)
       end
∀

x

∃

y
```

文字列の有効なインデックスを取得する必要がある場合は、前述のように [`nextind`](@ref) 関数と [`prevind`](@ref) 関数を使い、次または前の有効なインデックスへ進めたり戻したりできます。[`eachindex`](@ref) 関数を使って、有効な文字インデックスを反復処理することもできます。

```jldoctest unicodestring
julia> collect(eachindex(s))
7-element Vector{Int64}:
  1
  4
  5
  6
  7
 10
 11
```

エンコーディングの生のコード単位（UTF-8 ではバイト）にアクセスするには、[`codeunit(s,i)`](@ref) 関数を使います。このとき、インデックス `i` は `1` から [`ncodeunits(s)`](@ref) まで連続した値を取ります。[`codeunits(s)`](@ref) 関数は、これらの生のコード単位（バイト）に配列としてアクセスできる `AbstractVector{UInt8}` ラッパーを返します。

Julia の文字列には、無効な UTF-8 コード単位列を含めることができます。この規約により、任意のバイト列を `String` として扱えます。このような場合、コード単位列を左から右へ解析するときは、次のいずれかのビットパターンの先頭部分に一致する、最長の 8 ビットコード単位列を 1 文字とする規則が適用されます（各 `x` は `0` または `1` です）。

  * `0xxxxxxx`;
  * `110xxxxx` `10xxxxxx`;
  * `1110xxxx` `10xxxxxx` `10xxxxxx`;
  * `11110xxx` `10xxxxxx` `10xxxxxx` `10xxxxxx`;
  * `10xxxxxx`;
  * `11111xxx`.

特に、この規則により、過長なコード単位列や範囲を超える値を表すコード単位列、およびそれらの先頭部分は、複数の無効な文字ではなく、単一の無効な文字として扱われます。この規則は、例で説明するのがわかりやすいでしょう。

```julia-repl
julia> s = "\xc0\xa0\xe2\x88\xe2|"
"\xc0\xa0\xe2\x88\xe2|"

julia> foreach(display, s)
'\xc0\xa0': [overlong] ASCII/Unicode U+0020 (category Zs: Separator, space)
'\xe2\x88': Malformed UTF-8 (category Ma: Malformed, bad data)
'\xe2': Malformed UTF-8 (category Ma: Malformed, bad data)
'|': ASCII/Unicode U+007C (category Sm: Symbol, math)

julia> isvalid.(collect(s))
4-element BitArray{1}:
 0
 0
 0
 1

julia> s2 = "\xf7\xbf\xbf\xbf"
"\U1fffff"

julia> foreach(display, s2)
'\U1fffff': Unicode U+1FFFFF (category In: Invalid, too high)
```

文字列 `s` の最初の 2 つのコード単位は、空白文字の過長エンコーディングを構成しています。これは無効ですが、文字列中では単一の文字として受け入れられます。次の 2 つのコード単位は、3 バイトの UTF-8 列の有効な先頭部分を構成しています。しかし、5 番目のコード単位 `\xe2` は、その有効な継続バイトではありません。そのため、コード単位 3 と 4 も、この文字列ではひとまとまりの不正な文字として解釈されます。同様に、`|` はコード単位 5 に続く有効な継続バイトではないため、コード単位 5 も不正な文字を構成します。最後に、文字列 `s2` には、範囲を超えるコードポイントが 1 つ含まれています。

Julia はデフォルトで UTF-8 エンコーディングを使い、パッケージによって新しいエンコーディングへの対応を追加できます。たとえば、[LegacyStrings.jl](https://github.com/JuliaStrings/LegacyStrings.jl) パッケージは `UTF16String` 型と `UTF32String` 型を実装しています。ほかのエンコーディングや、それらへの対応の実装方法についての詳しい説明は、現時点ではこの文書の範囲外です。UTF-8 エンコーディングに関する問題について詳しくは、後述の [byte array literals](@ref man-byte-array-literals) の節を参照してください。さまざまな UTF-xx エンコーディング間でデータを変換するために、[`transcode`](@ref) 関数が用意されています。これは主に、外部のデータやライブラリを扱うためのものです。

## [Concatenation](@id man-concatenation)

最も一般的で便利な文字列操作の 1 つが連結です。

```jldoctest stringconcat
julia> greet = "Hello"
"Hello"

julia> whom = "world"
"world"

julia> string(greet, ", ", whom, ".\n")
"Hello, world.\n"
```

無効な UTF-8 文字列の連結など、潜在的に危険な状況には注意が必要です。結果の文字列には、入力文字列とは異なる文字が含まれることがあり、その文字数が連結した文字列の文字数の合計より少なくなる場合があります。たとえば次のようになります。

```jldoctest
julia> a, b = "\xe2\x88", "\x80"
("\xe2\x88", "\x80")

julia> c = string(a, b)
"∀"

julia> collect.([a, b, c])
3-element Vector{Vector{Char}}:
 ['\xe2\x88']
 ['\x80']
 ['∀']

julia> length.([a, b, c])
3-element Vector{Int64}:
 1
 1
 1
```

この状況が起こりうるのは、無効な UTF-8 文字列の場合だけです。有効な UTF-8 文字列を連結した場合、文字列中のすべての文字が保持され、文字列長の加法性も保たれます。

Julia では、文字列の連結に [`*`](@ref) も使えます。

```jldoctest stringconcat
julia> greet * ", " * whom * ".\n"
"Hello, world.\n"
```

文字列の連結に `+` を使う言語のユーザーには、`*` は意外な選択に見えるかもしれません。しかし、`*` のこの使い方には、数学、特に抽象代数学に先例があります。

数学では、`+` は通常、オペランドの順序によって結果が変わらない*可換*な演算を表します。その一例が行列の加算で、同じ形状の任意の行列 `A` と `B` に対して `A + B == B + A` が成り立ちます。一方、`*` は通常、オペランドの順序が*結果に影響する*、*非可換*な演算を表します。その一例が行列の乗算で、一般に `A * B != B * A` です。行列の乗算と同様に、文字列の連結も非可換です。`greet * whom != whom * greet` となります。そのため、文字列連結の中置演算子としては `*` のほうが自然であり、一般的な数学上の用法とも一致します。

より正確には、すべての有限長文字列の集合 *S* と文字列連結演算子 `*` は、[free monoid](https://en.wikipedia.org/wiki/Free_monoid)（*S*、`*`）をなします。この集合の単位元は空文字列 `""` です。自由モノイドが可換でない場合、その演算は通常 `\cdot`、`*`、または類似の記号で表されます。前述のように通常は可換性を意味する `+` は使いません。

## [Interpolation](@id string-interpolation)

ただし、連結を使って文字列を作成すると、少し煩雑になることがあります。冗長な [`string`](@ref) の呼び出しや乗算の繰り返しを減らすために、Julia では Perl と同様に、`$` を使って文字列リテラルに値を補間できます。

```jldoctest
julia> greet = "Hello"; whom = "world";

julia> "$greet, $whom.\n"
"Hello, world.\n"
```

この書き方は読みやすく便利で、上記の文字列連結と等価です。システムは、一見すると単一の文字列リテラルであるこの式を、`string(greet, ", ", whom, ".\n")` という呼び出しに書き換えます。

`$` に続く最短の完全な式が、文字列に補間する値を求める式として扱われます。したがって、括弧を使えば任意の式を文字列に補間できます。

```jldoctest
julia> "1 + 2 = $(1 + 2)"
"1 + 2 = 3"
```

連結と文字列補間は、どちらも [`string`](@ref) を呼び出してオブジェクトを文字列形式に変換します。ただし、`string` は実際には [`print`](@ref) の出力を返すだけなので、新しい型では `string` ではなく、[`print`](@ref) または [`show`](@ref) にメソッドを追加してください。

`AbstractString` 以外のほとんどのオブジェクトは、リテラル式として入力するときの表記に近い文字列に変換されます。

```jldoctest
julia> v = [1,2,3]
3-element Vector{Int64}:
 1
 2
 3

julia> "v: $v"
"v: [1, 2, 3]"
```

[`string`](@ref) は `AbstractString` と `AbstractChar` の値に対して恒等的に働くため、これらは引用符やエスケープを付けず、そのまま文字列に補間されます。

```jldoctest
julia> c = 'x'
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)

julia> "hi, $c"
"hi, x"
```

文字列リテラルに `$` そのものを含めるには、バックスラッシュでエスケープします。

```jldoctest
julia> print("I have \$100 in my account.\n")
I have $100 in my account.
```

## Triple-Quoted String Literals

三重引用符（`"""..."""`）で作成した文字列には、長いテキストの作成に便利な特別な動作があります。

まず、三重引用符で囲まれた文字列では、最もインデントの浅い行のレベルに合わせて共通のインデントが取り除かれます。これは、インデントされたコード内で文字列を定義する際に便利です。たとえば次のようになります。

```jldoctest
julia> str = """
           Hello,
           world.
         """
"  Hello,\n  world.\n"
```

この場合、閉じる `"""` の直前にある最後の（空の）行によって、インデントのレベルが決まります。

取り除くインデントは、すべての行の先頭に共通する、最長の空白またはタブの並びとして決定されます。ただし、開く `"""` の直後の行と、空白またはタブだけの行は対象から除外されます（閉じる `"""` を含む行は常に対象です）。その後、開く `"""` に続くテキストを除いたすべての行から、共通の先頭部分が取り除かれます（空白とタブだけの行も、その並びで始まっていれば取り除かれます）。たとえば次のようになります。

```jldoctest
julia> """    This
         is
           a test"""
"    This\nis\n  a test"
```

次に、開く `"""` の直後に改行がある場合、その改行は結果の文字列から取り除かれます。

```julia
"""hello"""
```

は、次と等価です。

```julia
"""
hello"""
```

一方、

```julia
"""

hello"""
```

では、先頭に改行文字が含まれます。

改行の除去は、インデントの除去後に行われます。たとえば次のようになります。

```jldoctest
julia> """
         Hello,
         world."""
"Hello,\nworld."
```

バックスラッシュを使って改行を取り除いた場合にも、インデントの除去は適用されます。

```jldoctest
julia> """
         Averylong\
         word"""
"Averylongword"
```

行末の空白はそのまま保持されます。

三重引用符で囲まれた文字列リテラルには、`"` 文字をエスケープせずに含めることができます。

文字列リテラル内の改行は、引用符が一重でも三重でも、文字列内では改行（LF）文字 `\n` になります。エディターが行末に復帰文字 `\r`（CR）や CRLF の組み合わせを使っていても同様です。文字列に CR を含めるには、明示的なエスケープ `\r` を使ってください。たとえば、文字列リテラル `"a CRLF line ending\r\n"` と入力できます。

## Common Operations

標準の比較演算子を使って、文字列を辞書式順序で比較できます。

```jldoctest
julia> "abracadabra" < "xylophone"
true

julia> "abracadabra" == "xylophone"
false

julia> "Hello, world." != "Goodbye, world."
true

julia> "1 + 2 = 3" == "1 + 2 = $(1 + 2)"
true
```

[`findfirst`](@ref) 関数と [`findlast`](@ref) 関数を使うと、特定の文字のインデックスを検索できます。

```jldoctest
julia> findfirst('o', "xylophone")
4

julia> findlast('o', "xylophone")
7

julia> findfirst('z', "xylophone")
```

[`findnext`](@ref) 関数と [`findprev`](@ref) 関数を使うと、指定した位置から文字の検索を開始できます。

```jldoctest
julia> findnext('o', "xylophone", 1)
4

julia> findnext('o', "xylophone", 5)
7

julia> findprev('o', "xylophone", 5)
4

julia> findnext('o', "xylophone", 8)
```

[`occursin`](@ref) 関数を使うと、ある部分文字列が文字列内に含まれているかどうかを確認できます。

```jldoctest
julia> occursin("world", "Hello, world.")
true

julia> occursin("o", "Xylophon")
true

julia> occursin("a", "Xylophon")
false

julia> occursin('o', "Xylophon")
true
```

最後の例が示すように、[`occursin`](@ref) では文字リテラルを検索することもできます。

ほかにも便利な文字列関数として、[`repeat`](@ref) と [`join`](@ref) があります。

```jldoctest
julia> repeat(".:Z:.", 10)
".:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:."

julia> join(["apples", "bananas", "pineapples"], ", ", " and ")
"apples, bananas and pineapples"
```

そのほか、次のような便利な関数があります。

  * [`firstindex(str)`](@ref) は、`str` へのアクセスに使える最小の（バイト）インデックスを返します（文字列では常に 1 ですが、ほかのコンテナでは必ずしもそうではありません）。
  * [`lastindex(str)`](@ref) は、`str` へのアクセスに使える最大の（バイト）インデックスを返します。
  * [`length(str)`](@ref) は、`str` の文字数を返します。
  * [`length(str, i, j)`](@ref) は、`str` の `i` から `j` までにある、有効な文字インデックスの数を返します。
  * [`ncodeunits(str)`](@ref) は、文字列内の [code units](https://en.wikipedia.org/wiki/Character_encoding#Terminology) の数を返します。
  * [`codeunit(str, i)`](@ref) は、文字列 `str` のインデックス `i` にあるコード単位の値を返します。
  * [`thisind(str, i)`](@ref) は、文字列内の任意のインデックスに対し、そのインデックスが指している文字の先頭インデックスを求めます。
  * [`nextind(str, i, n=1)`](@ref) は、インデックス `i` より後から数えて `n` 番目の文字の先頭を求めます。
  * [`prevind(str, i, n=1)`](@ref) は、インデックス `i` より前へ数えて `n` 番目の文字の先頭を求めます。

## [Non-Standard String Literals](@id non-standard-string-literals)

文字列を作成したり、文字列としての意味を利用したりしたくても、標準の文字列構文の動作では要件に合わない場合があります。このような場合のために、Julia は非標準文字列リテラルを提供しています。非標準文字列リテラルは、通常のダブルクォートで囲まれた文字列リテラルの直前に識別子を付けた形で記述し、通常の文字列リテラルとは異なる動作をすることがあります。

後述する [Regular expressions](@ref man-regex-literals)、[byte array literals](@ref man-byte-array-literals)、[version number literals](@ref man-version-number-literals) は、非標準文字列リテラルの例です。ユーザーやパッケージが新しい非標準文字列リテラルを定義することもできます。詳しくは [Metaprogramming](@ref meta-non-standard-string-literals) の節を参照してください。

## [Regular Expressions](@id man-regex-literals)

完全に一致する文字列ではなく、特定の*パターン*を探したい場合があります。たとえば、大きなテキストファイルから日付を 1 つ取り出したいとします。その日付自体はわかりません（だからこそ検索するのです）が、`YYYY-MM-DD` のような形式であることはわかっています。正規表現を使うと、このようなパターンを指定して検索できます。

Julia は、[PCRE](https://www.pcre.org/) ライブラリが提供する Perl 互換正規表現のバージョン 2 を使っています（詳しくは [PCRE2 syntax description](https://www.pcre.org/current/doc/html/pcre2syntax.html) を参照してください）。正規表現と文字列には、2 つの関係があります。明らかなのは、文字列中の規則的なパターンを見つけるために正規表現を使うという関係です。もう 1 つは、正規表現自体も文字列として入力され、それが解析されて、文字列内のパターンを効率よく検索できる状態機械になるという関係です。Julia では、`r` で始まる各種識別子を前置した非標準文字列リテラルで、正規表現を入力します。オプションを何も有効にしない最も基本的な正規表現リテラルでは、`r"..."` だけを使います。

```jldoctest
julia> re = r"^\s*(?:#|$)"
r"^\s*(?:#|$)"

julia> typeof(re)
Regex
```

正規表現が文字列にマッチするかどうかを確認するには、[`occursin`](@ref) を使います。

```jldoctest
julia> occursin(r"^\s*(?:#|$)", "not a comment")
false

julia> occursin(r"^\s*(?:#|$)", "# a comment")
true
```

この例からわかるように、[`occursin`](@ref) は、指定した正規表現にマッチする箇所が文字列内に存在するかどうかを、単に true または false で返します。ただし多くの場合、文字列がマッチしたかどうかだけでなく、*どのように*マッチしたかも知りたいものです。マッチに関するこの情報を取得するには、代わりに [`match`](@ref) 関数を使います。

```jldoctest
julia> match(r"^\s*(?:#|$)", "not a comment")

julia> match(r"^\s*(?:#|$)", "# a comment")
RegexMatch("#")
```

正規表現が指定した文字列にマッチしない場合、[`match`](@ref) は [`nothing`](@ref) を返します。これは、対話型プロンプトでは何も表示しない特別な値です。表示されない点を除けば通常の値であり、プログラムで判定できます。

```julia
m = match(r"^\s*(?:#|$)", line)
if m === nothing
    println("not a comment")
else
    println("blank or comment")
end
```

正規表現がマッチした場合、[`match`](@ref) が返す値は [`RegexMatch`](@ref) オブジェクトです。このオブジェクトは、パターンにマッチした部分文字列や、キャプチャされた部分文字列があればそれらも含め、正規表現がどのようにマッチしたかを記録します。この例ではマッチした部分文字列を取得するだけですが、コメント文字の後にある空白以外のテキストをキャプチャしたい場合もあるでしょう。その場合は次のようにできます。

```jldoctest
julia> m = match(r"^\s*(?:#\s*(.*?)\s*$)", "# a comment ")
RegexMatch("# a comment ", 1="a comment")
```

[`match`](@ref) を呼び出す際には、検索を開始するインデックスを指定することもできます。たとえば次のようにします。

```jldoctest
julia> m = match(r"[0-9]","aaaa1aaaa2aaaa3",1)
RegexMatch("1")

julia> m = match(r"[0-9]","aaaa1aaaa2aaaa3",6)
RegexMatch("2")

julia> m = match(r"[0-9]","aaaa1aaaa2aaaa3",11)
RegexMatch("3")
```

`RegexMatch` オブジェクトからは、次の情報を取り出せます。

  * マッチした部分文字列全体：`m.match`
  * キャプチャされた部分文字列を格納した文字列配列：`m.captures`
  * マッチ全体が始まるオフセット：`m.offset`
  * キャプチャされた部分文字列のオフセットを格納したベクトル：`m.offsets`

キャプチャがマッチしなかった場合、`m.captures` のその位置には、部分文字列の代わりに `nothing` が入り、`m.offsets` のオフセットは 0 になります（Julia のインデックスは 1 から始まるため、文字列に対するオフセット 0 は無効であることを思い出してください）。少し作為的ですが、次の 2 つの例で示します。

```jldoctest acdmatch
julia> m = match(r"(a|b)(c)?(d)", "acd")
RegexMatch("acd", 1="a", 2="c", 3="d")

julia> m.match
"acd"

julia> m.captures
3-element Vector{Union{Nothing, SubString{String}}}:
 "a"
 "c"
 "d"

julia> m.offset
1

julia> m.offsets
3-element Vector{Int64}:
 1
 2
 3

julia> m = match(r"(a|b)(c)?(d)", "ad")
RegexMatch("ad", 1="a", 2=nothing, 3="d")

julia> m.match
"ad"

julia> m.captures
3-element Vector{Union{Nothing, SubString{String}}}:
 "a"
 nothing
 "d"

julia> m.offset
1

julia> m.offsets
3-element Vector{Int64}:
 1
 0
 2
```

キャプチャが配列として返されると、分解構文を使ってローカル変数に束縛できるので便利です。さらに便利なことに、`RegexMatch` オブジェクトには `captures` フィールドに処理を委譲するイテレーターメソッドが実装されているため、マッチオブジェクトを直接分解できます。

```jldoctest acdmatch
julia> first, second, third = m; first
"a"
```

キャプチャグループの番号や名前をインデックスとして `RegexMatch` オブジェクトにアクセスすることでも、キャプチャを取得できます。

```jldoctest
julia> m=match(r"(?<hour>\d+):(?<minute>\d+)","12:45")
RegexMatch("12:45", hour="12", minute="45")

julia> m[:minute]
"45"

julia> m[2]
"45"
```

[`replace`](@ref) を使う場合、置換文字列に `s` を前置し、`\n` で n 番目のキャプチャグループを参照することで、置換文字列内からキャプチャを参照できます。キャプチャグループ 0 はマッチ全体を指します。名前付きキャプチャグループは、置換文字列内で `\g<groupname>` によって参照できます。たとえば次のようにします。

```jldoctest
julia> replace("first second", r"(\w+) (?<agroup>\w+)" => s"\g<agroup> \1")
"second first"
```

番号付きキャプチャグループは、曖昧さを避けるために `\g<n>` として参照することもできます。

```jldoctest
julia> replace("a", r"." => s"\g<0>1")
"a1"
```

閉じるダブルクォートの後に、フラグ `i`、`m`、`s`、`x` を組み合わせて付けると、正規表現の動作を変更できます。これらのフラグの意味は Perl と同じです。[perlre manpage](https://perldoc.perl.org/perlre#Modifiers) からの次の抜粋で説明されています。

```
i   Do case-insensitive pattern matching.

    If locale matching rules are in effect, the case map is taken
    from the current locale for code points less than 255, and
    from Unicode rules for larger code points. However, matches
    that would cross the Unicode rules/non-Unicode rules boundary
    (ords 255/256) will not succeed.

m   Treat string as multiple lines. That is, change "^" and "$"
    from matching the start or end of the string to matching the
    start or end of any line anywhere within the string.

s   Treat string as single line. That is, change "." to match any
    character whatsoever, even a newline, which normally it would
    not match.

    Used together, as r""ms, they let the "." match any character
    whatsoever, while still allowing "^" and "$" to match,
    respectively, just after and just before newlines within the
    string.

x   Tells the regular expression parser to ignore most whitespace
    that is neither backslashed nor within a character class. You
    can use this to break up your regular expression into
    (slightly) more readable parts. The '#' character is also
    treated as a metacharacter introducing a comment, just as in
    ordinary code.
```

たとえば、次の正規表現では 3 つのフラグをすべて有効にしています。

```jldoctest
julia> r"a+.*b+.*d$"ism
r"a+.*b+.*d$"ims

julia> match(r"a+.*b+.*d$"ism, "Goodbye,\nOh, angry,\nBad world\n")
RegexMatch("angry,\nBad world")
```

`r"..."` リテラルは、補間やエスケープの展開を行わずに構築されます（ただし、引用符 `"` は引き続きエスケープが必要です）。通常の文字列リテラルとの違いを、次の例で示します。

```jldoctest
julia> x = 10
10

julia> r"$x"
r"$x"

julia> "$x"
"10"

julia> r"\x"
r"\x"

julia> "\x"
ERROR: ParseError:
# Error @ none:1:2
"\x"
#└┘ ── invalid hex escape sequence
```

`r"""..."""` という形式の、三重引用符で囲まれた正規表現文字列もサポートされています（引用符や改行を含む正規表現では便利な場合があります）。

`Regex()` コンストラクターを使うと、プログラムで有効な正規表現文字列を作成できます。これにより、正規表現文字列の構築時に、文字列変数の内容やその他の文字列操作を利用できます。`Regex()` に渡す単一の文字列引数の中では、上記の正規表現コードをどれでも使えます。いくつか例を示します。

```jldoctest
julia> using Dates

julia> d = Date(1962,7,10)
1962-07-10

julia> regex_d = Regex("Day " * string(day(d)))
r"Day 10"

julia> match(regex_d, "It happened on Day 10")
RegexMatch("Day 10")

julia> name = "Jon"
"Jon"

julia> regex_name = Regex("[\"( ]\\Q$name\\E[\") ]")  # interpolate value of name
r"[\"( ]\QJon\E[\") ]"

julia> match(regex_name, " Jon ")
RegexMatch(" Jon ")

julia> match(regex_name, "[Jon]") === nothing
true
```

`\Q...\E` エスケープシーケンスの使い方に注意してください。`\Q` と `\E` の間の文字は、すべて文字どおりに解釈されます。これは、通常なら正規表現のメタ文字として扱われる文字にマッチさせる際に便利です。ただし、この機能を文字列補間と併用する場合は注意が必要です。補間される文字列自体に `\E` の並びが含まれていると、文字どおりのマッチが意図せず終了する可能性があるためです。ユーザー入力を正規表現に組み込む前には、無害化する必要があります。

## [Byte Array Literals](@id man-byte-array-literals)

もう 1 つの便利な非標準文字列リテラルが、バイト配列文字列リテラル `b"..."` です。この形式では、文字列の表記を使って、読み取り専用のバイト配列リテラル、つまり [`UInt8`](@ref) 値の配列を表現できます。これらのオブジェクトの型は `CodeUnits{UInt8, String}` です。バイト配列リテラルには、次の規則が適用されます。

  * ASCII 文字と ASCII エスケープは、単一のバイトを生成します。
  * `\x` と 8 進エスケープシーケンスは、エスケープ値に対応する*バイト*を生成します。
  * Unicode エスケープシーケンスは、そのコードポイントを UTF-8 でエンコードしたバイト列を生成します。

0x80（128）未満の `\x` と 8 進エスケープの動作は最初の 2 つの規則の両方に該当するため、規則には一部重複があります。ただし、この場合はどちらの規則でも結果は一致します。これらの規則を組み合わせることで、ASCII 文字、任意のバイト値、UTF-8 列を使って簡単にバイト配列を作成できます。次は、その 3 つすべてを使った例です。

```jldoctest
julia> b"DATA\xff\u2200"
8-element Base.CodeUnits{UInt8, String}:
 0x44
 0x41
 0x54
 0x41
 0xff
 0xe2
 0x88
 0x80
```

ASCII 文字列 "DATA" は、バイト 68、65、84、65 に対応します。`\xff` は単一のバイト 255 を生成します。Unicode エスケープ `\u2200` は、UTF-8 では 226、136、128 の 3 バイトにエンコードされます。結果のバイト配列は、有効な UTF-8 文字列には対応しないことに注意してください。

```jldoctest
julia> isvalid("DATA\xff\u2200")
false
```

前述のように、`CodeUnits{UInt8, String}` 型は `UInt8` の読み取り専用配列として振る舞います。通常のベクトルが必要な場合は、`Vector{UInt8}` を使って変換できます。

```jldoctest
julia> x = b"123"
3-element Base.CodeUnits{UInt8, String}:
 0x31
 0x32
 0x33

julia> x[1]
0x31

julia> x[1] = 0x32
ERROR: CanonicalIndexError: setindex! not defined for Base.CodeUnits{UInt8, String}
[...]

julia> Vector{UInt8}(x)
3-element Vector{UInt8}:
 0x31
 0x32
 0x33
```

また、`\xff` と `\uff` の重要な違いにも注意してください。前者のエスケープシーケンスは*バイト値 255*をエンコードしますが、後者は*コードポイント 255*を表し、UTF-8 では 2 バイトにエンコードされます。

```jldoctest
julia> b"\xff"
1-element Base.CodeUnits{UInt8, String}:
 0xff

julia> b"\uff"
2-element Base.CodeUnits{UInt8, String}:
 0xc3
 0xbf
```

文字リテラルでも同じ動作になります。

`\u80` 未満のコードポイントでは、各コードポイントの UTF-8 エンコーディングが、対応する `\x` エスケープによって生成される単一のバイトと一致するため、この違いは無視しても問題ありません。しかし、`\x80` から `\xff` までのエスケープと、`\u80` から `\uff` までのエスケープには、大きな違いがあります。前者はいずれも単一のバイトをエンコードし、特定の継続バイトが後続しない限り有効な UTF-8 データにはなりません。一方、後者はいずれも、2 バイトでエンコードされる Unicode コードポイントを表します。

ここまでの内容がとてもわかりにくく感じられる場合は、["The Absolute Minimum Every Software Developer Absolutely, Positively Must Know About Unicode and Character Sets"](https://www.joelonsoftware.com/2003/10/08/the-absolute-minimum-every-software-developer-absolutely-positively-must-know-about-unicode-and-character-sets-no-excuses/) を読んでみてください。Unicode と UTF-8 の優れた入門資料で、この話題に関する混乱をいくらか解消できるかもしれません。

## [Version Number Literals](@id man-version-number-literals)

バージョン番号は、[`v"..."`](@ref @v_str) という形式の非標準文字列リテラルで簡単に表現できます。バージョン番号リテラルは、[semantic versioning 2.0.0-rc2](https://semver.org/spec/v2.0.0-rc.2.html) の仕様に従う [`VersionNumber`](@ref) オブジェクトを作成します。そのため、メジャー、マイナー、パッチの数値と、それに続く英数字のプレリリースおよびビルドの注釈で構成されます。たとえば、`v"0.2.1-rc1+win64"` は、メジャーバージョン `0`、マイナーバージョン `2`、パッチバージョン `1`、プレリリース `rc1`、ビルド `win64` に分かれます。バージョンリテラルを入力するときは、メジャーバージョン番号以外はすべて省略可能です。したがって、たとえば `v"0.2"` は `v"0.2.0"` と等価で（プレリリースとビルドの注釈は空）、`v"2"` は `v"2.0.0"` と等価です。

`VersionNumber` オブジェクトは、主に 2 つ以上のバージョンを簡単かつ正しく比較するために役立ちます。たとえば、定数 [`VERSION`](@ref) は Julia のバージョン番号を `VersionNumber` オブジェクトとして保持しているため、次のような単純な文でバージョン固有の動作を定義できます。

```julia
if v"0.2" <= VERSION < v"0.3-"
    # do something specific to 0.2 release series
end
```

上の例では、末尾に `-` を付けた非標準のバージョン番号 `v"0.3-"` を使っていることに注意してください。この表記は標準に対する Julia の拡張であり、すべてのプレリリースを含め、どの `0.3` リリースよりも低いバージョンを示すために使います。したがって、上の例のコードは安定版の `0.2` バージョンでのみ実行され、`v"0.3.0-rc1"` のようなバージョンは除外されます。不安定版（つまりプレリリース）の `0.2` バージョンも許可するには、下限の検査を `v"0.2-" <= VERSION` のように変更します。

バージョン指定のもう 1 つの非標準拡張では、末尾に `+` を付けてビルドバージョンの上限を表現できます。たとえば、`VERSION > v"0.2-rc1+"` は、`0.2-rc1` とそのすべてのビルドよりも上のバージョンを意味するために使えます。これは、バージョン `v"0.2-rc1+win64"` に対して `false` を、`v"0.2-rc2"` に対して `true` を返します。

比較では、このような特別なバージョンを使うことが推奨されます（特に上限では、使わない明確な理由がない限り、末尾の `-` を常に使ってください）。ただし、これらはセマンティックバージョニングの規則では無効なので、実際のバージョン番号として使ってはいけません。

`VersionNumber` オブジェクトは、[`VERSION`](@ref) 定数に使われるだけでなく、`Pkg` モジュールでも、パッケージのバージョンや依存関係の指定に広く使われています。

## [Raw String Literals](@id man-raw-string-literals)

補間やエスケープの展開を行わない raw 文字列は、`raw"..."` という形式の非標準文字列リテラルで表現できます。raw 文字列リテラルは、補間やエスケープの展開をせず、囲まれた内容を入力したとおりに含む、通常の `String` オブジェクトを作成します。これは、`$` や `\` を特殊文字として使うほかの言語のコードやマークアップを含む文字列に便利です。

例外として、引用符は引き続きエスケープする必要があります。たとえば、`raw"\""` は `"\""` と等価です。あらゆる文字列を表現できるようにするため、バックスラッシュもエスケープが必要ですが、引用符の直前に現れる場合だけです。

```jldoctest
julia> println(raw"\\ \\\"")
\\ \"
```

最初の 2 つのバックスラッシュは、引用符の前にないため、そのまま出力に現れることに注意してください。一方、その次のバックスラッシュは後続するバックスラッシュをエスケープし、最後のバックスラッシュは引用符をエスケープします。これらのバックスラッシュは引用符の前にあるためです。

## [Annotated Strings](@id man-annotated-strings)

!!! note
    AnnotatedStrings の API は実験的なものとされており、Julia のバージョン間で変更される可能性があります。


文字列内の領域に関連するメタデータを保持できると便利な場合があります。[`AnnotatedString`](@ref Base.AnnotatedString) は別の文字列をラップし、その領域にラベル付きの値（`:label => value`）を注釈として付けられるようにします。汎用的な文字列操作はすべて、内部の文字列に適用されます。ただし、可能な場合はスタイル情報が保持されます。つまり、[`AnnotatedString`](@ref Base.AnnotatedString) に対して、部分文字列の取り出し、パディング、ほかの文字列との連結などの操作を行っても、メタデータの注釈が「一緒についてくる」ということです。

この文字列型は [StyledStrings stdlib](@ref stdlib-styledstrings) の基盤となるものです。そこでは、`:face` をラベルとする注釈を使ってスタイル情報を保持します。

[`AnnotatedString`](@ref Base.AnnotatedString) を連結するときに文字列の注釈を保持したい場合は、[`string`](@ref) ではなく [`annotatedstring`](@ref Base.annotatedstring) を使うように注意してください。

```jldoctest
julia> str = Base.AnnotatedString("hello there",
               [(1:5, :word, :greeting), (7:11, :label, 1)])
"hello there"

julia> length(str)
11

julia> lpad(str, 14)
"   hello there"

julia> typeof(lpad(str, 7))
Base.AnnotatedString{String}

julia> str2 = Base.AnnotatedString(" julia", [(2:6, :face, :magenta)])
" julia"

julia> Base.annotatedstring(str, str2)
"hello there julia"

julia> str * str2 == Base.annotatedstring(str, str2) # *-concatenation still works
true
```

[`AnnotatedString`](@ref Base.AnnotatedString) の注釈は、[`annotations`](@ref Base.annotations) 関数と [`annotate!`](@ref Base.annotate!) 関数を通じて取得・変更できます。
