# [Strings](@id man-strings)

文字列は、文字の有限列です。もちろん、文字とは何かを考え始めると、話は複雑になります。英語話者になじみのある文字は、`A`、`B`、`C`などの文字に、数字や一般的な句読点を加えたものです。これらの文字と、0から127までの整数値との対応は、[ASCII](https://en.wikipedia.org/wiki/ASCII)規格で標準化されています。もちろん、英語以外の言語で使われる文字も数多くあります。アクセント記号などの修飾を加えたASCII文字、キリル文字やギリシャ文字などの関連する文字体系、さらにはアラビア語、中国語、ヘブライ語、ヒンディー語、日本語、韓国語など、ASCIIや英語とはまったく異なる文字体系もあります。[Unicode](https://en.wikipedia.org/wiki/Unicode)規格は、文字とは何かという複雑な問題に取り組むものであり、この問題に対処する決定的な規格として一般に認められています。必要に応じて、こうした複雑さをすべて無視し、ASCII文字だけが存在するとみなすことも、非ASCIIテキストを扱う際に遭遇しうるあらゆる文字やエンコーディングに対応できるコードを書くこともできます。Juliaでは、プレーンなASCIIテキストを簡単かつ効率的に扱えます。また、Unicodeの処理も可能な限り簡単かつ効率的です。特に、ASCII文字列を処理するCスタイルの文字列コードを書けば、性能と意味の両面で期待どおりに動作します。そのようなコードが非ASCIIテキストに遭遇した場合は、破損した結果を黙って生成するのではなく、明確なエラーメッセージを出して安全に失敗します。その場合も、非ASCIIデータを扱えるようにコードを修正するのは簡単です。

Juliaの文字列には、次のような注目すべき高水準の特徴があります。

  * Juliaで文字列（および文字列リテラル）に使われる組み込みの具象型は、[`String`](@ref)です。この型は、[Unicode](https://en.wikipedia.org/wiki/Unicode)の全範囲を[UTF-8](https://en.wikipedia.org/wiki/UTF-8)エンコーディングで扱えます。（他のUnicodeエンコーディングとの相互変換には、[`transcode`](@ref)関数を使います。）
  * すべての文字列型は抽象型`AbstractString`のサブタイプです。また、外部パッケージでは、追加の`AbstractString`サブタイプ（たとえば、他のエンコーディング用の型）が定義されています。文字列を引数に取る関数を定義する場合は、あらゆる文字列型を受け入れられるよう、型を`AbstractString`と宣言してください。
  * CやJavaと同様に、また多くの動的言語とは異なり、Juliaには単一の文字を表す第一級の型があり、[`AbstractChar`](@ref)と呼ばれます。組み込みの[`Char`](@ref)は`AbstractChar`のサブタイプで、あらゆるUnicode文字を表現できる32ビットのプリミティブ型です（UTF-8エンコーディングに基づいています）。
  * Javaと同様に、文字列は不変です。つまり、`AbstractString`オブジェクトの値は変更できません。別の文字列値を作るには、他の文字列の一部から新しい文字列を構築します。
  * 概念的には、文字列はインデックスから文字への*部分関数*です。インデックス値によっては文字が返されず、代わりに例外がスローされます。これにより、Unicode文字列の可変幅エンコーディングでは効率性と単純さを両立できない文字インデックスではなく、エンコード表現のバイトインデックスを使って文字列を効率的にインデックスできます。

## [Characters](@id man-characters)

`Char`値は単一の文字を表します。これは、特殊なリテラル表記と適切な算術演算を備え、[Unicode code point](https://en.wikipedia.org/wiki/Code_point)を表す数値に変換できる、32ビットのプリミティブ型です。（Juliaのパッケージでは、たとえば他の[text encodings](https://en.wikipedia.org/wiki/Character_encoding)での操作を最適化するために、`AbstractChar`の別のサブタイプを定義できます。）`Char`値の入力方法と表示方法を以下に示します（文字リテラルは二重引用符ではなく、単一引用符で囲みます）。

```jldoctest
julia> c = 'x'
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)

julia> typeof(c)
Char
```

`Char`を整数値、つまりコードポイントに簡単に変換できます。

```jldoctest
julia> c = Int('x')
120

julia> typeof(c)
Int64
```

32ビットアーキテクチャでは、[`typeof(c)`](@ref)は[`Int32`](@ref)になります。整数値から`Char`への変換も同様に簡単です。

```jldoctest
julia> Char(120)
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)
```

すべての整数値が有効なUnicodeコードポイントとは限りませんが、性能上の理由から、`Char`変換では、各文字値が有効かどうかを検査しません。変換後の値がそれぞれ有効なコードポイントか確認するには、[`isvalid`](@ref)関数を使います。

```jldoctest
julia> Char(0x110000)
'\U110000': Unicode U+110000 (category In: Invalid, too high)

julia> isvalid(Char, 0x110000)
false
```

執筆時点で有効なUnicodeコードポイントは、`U+0000`から`U+D7FF`まで、および`U+E000`から`U+10FFFF`までです。これらすべてに理解可能な意味が割り当てられているわけではなく、アプリケーションで解釈できるとも限りませんが、いずれも有効なUnicode文字とみなされます。

単一引用符で囲んだUnicode文字は、`\u`の後に最大4桁の16進数を続けるか、`\U`の後に最大8桁の16進数を続けることで入力できます（有効な値の最大長は6桁です）。

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

Juliaはシステムのロケールと言語設定に基づいて、そのまま表示できる文字と、汎用のエスケープ形式である`\u`または`\U`を使って出力する必要がある文字を判断します。これらのUnicodeエスケープ形式に加えて、[C's traditional escaped input forms](https://en.wikipedia.org/wiki/C_syntax#Backslash_escapes)もすべて使用できます。

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

`Char`値に対して、比較や限られた範囲の算術演算を行えます。

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

文字列リテラルは、二重引用符または三重二重引用符で囲みます（単一引用符ではありません）。

```jldoctest helloworldstring
julia> str = "Hello, world.\n"
"Hello, world.\n"

julia> """Contains "quote" characters"""
"Contains \"quote\" characters"
```

文字列内の長い行は、改行の前にバックスラッシュ（`\`）を置くことで分割できます。

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

文字列を含む多くのJuliaオブジェクトは、整数でインデックス指定できます。最初の要素（文字列の場合は最初の文字）のインデックスは[`firstindex(str)`](@ref)で、最後の要素（文字）のインデックスは[`lastindex(str)`](@ref)で取得できます。インデックス操作では、キーワード`begin`と`end`を、それぞれ指定した次元の最初と最後のインデックスの略記として使えます。Juliaのほとんどのインデックス指定と同様に、文字列のインデックスも1始まりです。`firstindex`は、どの`AbstractString`に対しても常に`1`を返します。ただし後述するように、文字列では`lastindex(str)`と`length(str)`は一般に同じではありません。Unicode文字の中には、複数の「コード単位」を占めるものがあるためです。

通常の値と同じように、[`end`](@ref)を使って算術演算やその他の操作を行えます。

```jldoctest helloworldstring
julia> str[end-1]
'.': ASCII/Unicode U+002E (category Po: Punctuation, other)

julia> str[end÷2]
' ': ASCII/Unicode U+0020 (category Zs: Separator, space)
```

`begin`（`1`）より小さいインデックス、または`end`より大きいインデックスを使うと、エラーが発生します。

```jldoctest helloworldstring
julia> str[begin-1]
ERROR: BoundsError: attempt to access 14-codeunit String at index [0]
[...]

julia> str[end+1]
ERROR: BoundsError: attempt to access 14-codeunit String at index [15]
[...]
```

範囲インデックスを使って部分文字列を取り出すこともできます。

```jldoctest helloworldstring
julia> str[4:9]
"lo, wo"
```

`str[k]`と`str[k:k]`の式は、同じ結果にならないことに注意してください。

```jldoctest helloworldstring
julia> str[6]
',': ASCII/Unicode U+002C (category Po: Punctuation, other)

julia> str[6:6]
","
```

前者は`Char`型の単一の文字値ですが、後者はたまたま1文字だけを含む文字列値です。Juliaでは、この2つはまったく異なるものです。

範囲インデックスを使うと、選択した部分が元の文字列からコピーされます。代わりに、[`SubString`](@ref)型を使って文字列のビューを作成することもできます。さらに簡単な方法として、コードブロックに[`@views`](@ref)マクロを適用すると、すべての文字列スライスが部分文字列に変換されます。たとえば、次のようになります。

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

[`chop`](@ref)、[`chomp`](@ref)、[`strip`](@ref)などの標準関数は、[`SubString`](@ref)を返します。

## Unicode and UTF-8

JuliaはUnicode文字と文字列を完全にサポートしています。[discussed above](@ref man-characters)と同様に、文字リテラルではUnicodeコードポイントをUnicodeの`\u`および`\U`エスケープシーケンスで表せるほか、標準的なCのエスケープシーケンスもすべて使えます。これらは文字列リテラルにも使用できます。

```jldoctest unicodestring
julia> s = "\u2200 x \u2203 y"
"∀ x ∃ y"
```

Unicode文字がエスケープ形式で表示されるか、特殊文字として表示されるかは、端末のロケール設定とUnicodeのサポート状況によって異なります。文字列リテラルはUTF-8でエンコードされます。UTF-8は可変幅エンコーディングであり、すべての文字が同じバイト数（「コード単位」数）でエンコードされるわけではありません。UTF-8では、ASCII文字、つまりコードポイントが0x80（128）未満の文字は、ASCIIと同じく1バイトでエンコードされます。一方、0x80以上のコードポイントは複数バイトでエンコードされ、1文字あたり最大4バイトを使います。

Juliaの文字列インデックスは、任意の文字（コードポイント）をエンコードするための固定幅の構成単位であるコード単位（UTF-8ではバイト）を指します。そのため、`String`内のすべてのインデックスが、必ずしも文字の有効なインデックスとは限りません。このような無効なバイトインデックスで文字列をインデックス指定すると、エラーが発生します。

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

この例では、文字`∀`は3バイト文字なので、インデックス2と3は無効で、次の文字のインデックスは4です。この次の有効なインデックスは[`nextind(s,1)`](@ref)で計算でき、そのさらに次のインデックスは`nextind(s,4)`で求められます。

`end`は常にコレクション内の最後の有効なインデックスなので、2番目に最後の文字がマルチバイト文字の場合、`end-1`は無効なバイトインデックスを参照します。

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

最初の例が機能するのは、最後の文字`y`と空白がどちらも1バイト文字だからです。一方、`end-2`は、マルチバイト文字`∃`の表現の途中を指します。この場合は`prevind(s, lastindex(s), 2)`を使うのが正しい方法です。また、その値を`s`のインデックスとして使う場合は、`s[prevind(s, end, 2)]`と書けます。`end`は`lastindex(s)`に展開されます。

範囲インデックスによる部分文字列の取り出しでも、有効なバイトインデックスが必要です。無効なインデックスを指定するとエラーが発生します。

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

可変長エンコーディングのため、文字列の文字数（[`length(s)`](@ref)で取得）は、最後のインデックスと常に一致するとは限りません。1から[`lastindex(s)`](@ref)までのインデックスを順にたどって`s`をインデックス指定すると、エラーにならずに返される文字の並びは、文字列`s`を構成する文字の並びになります。したがって、文字列内の各文字にはそれぞれ固有のインデックスが必要なので、`length(s) <= lastindex(s)`となります。以下は、`s`の文字を反復処理する、非効率で冗長な方法です。

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

空行には実際には空白が含まれています。幸い、文字列の文字を反復処理する際に、上記のような扱いにくい書き方をする必要はありません。文字列を反復可能オブジェクトとしてそのまま使えばよく、例外処理も不要です。

```jldoctest unicodestring
julia> for c in s
           println(c)
       end
∀

x

∃

y
```

文字列の有効なインデックスを取得する必要がある場合は、前述のように[`nextind`](@ref)関数と[`prevind`](@ref)関数を使って、次または前の有効なインデックスに進めたり戻したりできます。また、[`eachindex`](@ref)関数を使うと、有効な文字インデックスを反復処理できます。

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

エンコーディングの生のコード単位（UTF-8ではバイト）にアクセスするには、[`codeunit(s,i)`](@ref)関数を使います。このとき、インデックス`i`は`1`から[`ncodeunits(s)`](@ref)まで連続します。[`codeunits(s)`](@ref)関数は、これらの生のコード単位（バイト）に配列としてアクセスできる`AbstractVector{UInt8}`ラッパーを返します。

Juliaの文字列には、無効なUTF-8コード単位列を含めることができます。この規約により、任意のバイト列を`String`として扱えます。このような場合、コード単位列を左から右へ解析するとき、次のビットパターンのいずれかの先頭に一致する最長の8ビットコード単位列が文字を構成する、という規則が適用されます（各`x`は`0`または`1`です）。

  * `0xxxxxxx`;
  * `110xxxxx` `10xxxxxx`;
  * `1110xxxx` `10xxxxxx` `10xxxxxx`;
  * `11110xxx` `10xxxxxx` `10xxxxxx` `10xxxxxx`;
  * `10xxxxxx`;
  * `11111xxx`.

特に、長すぎるコード単位列や値が大きすぎるコード単位列、およびそれらの接頭辞は、複数の無効な文字ではなく、単一の無効な文字として扱われます。この規則は、次の例で説明できます。

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

文字列`s`の最初の2つのコード単位は、空白文字を過剰に長い形式でエンコードしています。これは無効ですが、文字列内では単一の文字として受け入れられます。次の2つのコード単位は、3バイトUTF-8シーケンスの有効な開始部分を構成します。しかし、5番目のコード単位`\xe2`は、有効な継続バイトではありません。そのため、この文字列ではコード単位3と4も不正な文字として解釈されます。同様に、コード単位5も不正な文字を構成します。`|`はその有効な継続バイトではないためです。最後に、文字列`s2`には、値が大きすぎるコードポイントが1つ含まれています。

JuliaはデフォルトでUTF-8エンコーディングを使いますが、パッケージを使って新しいエンコーディングのサポートを追加できます。たとえば、[LegacyStrings.jl](https://github.com/JuliaStrings/LegacyStrings.jl)パッケージは、`UTF16String`型と`UTF32String`型を実装しています。他のエンコーディングやそのサポート方法についての詳しい説明は、現時点ではこの文書の範囲外です。UTF-8エンコーディングの問題については、以下の[byte array literals](@ref man-byte-array-literals)の節を参照してください。さまざまなUTF-xxエンコーディング間でデータを変換するには、[`transcode`](@ref)関数を使います。主に外部データやライブラリを扱う際に利用します。

## [Concatenation](@id man-concatenation)

最も一般的で便利な文字列操作の1つが、文字列の連結です。

```jldoctest stringconcat
julia> greet = "Hello"
"Hello"

julia> whom = "world"
"world"

julia> string(greet, ", ", whom, ".\n")
"Hello, world.\n"
```

無効なUTF-8文字列を連結するなど、問題を引き起こす可能性のある状況には注意が必要です。連結後の文字列に含まれる文字が入力文字列と異なる場合があり、文字数も、連結した各文字列の文字数の合計より少なくなることがあります。たとえば、次のようになります。

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

この状況が起こるのは、無効なUTF-8文字列の場合に限られます。有効なUTF-8文字列を連結すれば、すべての文字が保持され、文字列の長さの加法性も保たれます。

Juliaでは、文字列連結に[`*`](@ref)も使えます。

```jldoctest stringconcat
julia> greet * ", " * whom * ".\n"
"Hello, world.\n"
```

文字列連結に`+`を使う言語に慣れたユーザーには、`*`は意外な選択に思えるかもしれません。しかし、`*`をこのように使うことは、特に抽象代数学などの数学に前例があります。

数学では、`+`は通常、オペランドの順序に依存しない*可換*演算を表します。たとえば行列の加算では、同じ形状の任意の行列`A`と`B`について、`A + B == B + A`が成り立ちます。これに対して、`*`は通常、オペランドの順序が*重要な*非可換演算を表します。たとえば行列の乗算では、一般に`A * B != B * A`です。行列の乗算と同様に、文字列連結も非可換です。つまり、`greet * whom != whom * greet`です。そのため、一般的な数学の用法に沿った中置文字列連結演算子としては、`*`のほうが自然です。

より正確には、有限長文字列全体の集合*S*と文字列連結演算子`*`は、[free monoid](https://en.wikipedia.org/wiki/Free_monoid)（*S*、`*`）を成します。この集合の単位元は空文字列`""`です。自由モノイドが非可換である場合、その演算は通常、`\cdot`、`*`、または類似の記号で表されます。一般に可換性を示唆する`+`は使いません。

## [Interpolation](@id string-interpolation)

ただし、連結を使って文字列を構築すると、少し煩雑になることがあります。[`string`](@ref)の冗長な呼び出しや、繰り返しの乗算を減らすため、JuliaではPerlと同様に、`$`を使って文字列リテラルに値を埋め込めます。

```jldoctest
julia> greet = "Hello"; whom = "world";

julia> "$greet, $whom.\n"
"Hello, world.\n"
```

この方法は読みやすく便利で、上記の文字列連結と同じ結果になります。システムは、見かけ上は単一の文字列リテラルであるものを、`string(greet, ", ", whom, ".\n")`の呼び出しに書き換えます。

`$`の後に続く最短の完全な式が、その値を文字列に埋め込む式として扱われます。そのため、括弧を使えば任意の式を文字列に埋め込めます。

```jldoctest
julia> "1 + 2 = $(1 + 2)"
"1 + 2 = 3"
```

連結と文字列補間はどちらも、オブジェクトを文字列形式に変換するために[`string`](@ref)を呼び出します。ただし、`string`は実際には[`print`](@ref)の出力をそのまま返すだけです。そのため、新しい型では`string`ではなく、[`print`](@ref)または[`show`](@ref)にメソッドを追加してください。

ほとんどの非`AbstractString`オブジェクトは、リテラル式として入力したときの表記に近い形式の文字列に変換されます。

```jldoctest
julia> v = [1,2,3]
3-element Vector{Int64}:
 1
 2
 3

julia> "v: $v"
"v: [1, 2, 3]"
```

[`string`](@ref)は`AbstractString`値と`AbstractChar`値に対する恒等関数です。そのため、これらの値は引用符やエスケープを付けず、そのまま文字列に埋め込まれます。

```jldoctest
julia> c = 'x'
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)

julia> "hi, $c"
"hi, x"
```

文字列リテラルに`$`をそのまま含めるには、バックスラッシュでエスケープします。

```jldoctest
julia> print("I have \$100 in my account.\n")
I have $100 in my account.
```

## Triple-Quoted String Literals

三重引用符（`"""..."""`）で文字列を作成すると、長いテキストブロックを作る際に便利な、いくつかの特別な動作があります。

まず、三重引用符で囲んだ文字列では、最もインデントの少ない行に合わせてインデントが削除されます。これは、インデントされたコード内で文字列を定義する場合に便利です。たとえば、次のようになります。

```jldoctest
julia> str = """
           Hello,
           world.
         """
"  Hello,\n  world.\n"
```

この例では、閉じる`"""`の前にある最後の（空の）行によって、インデントのレベルが決まります。

インデントの削除量は、先頭の`"""`の直後の行と、空白またはタブだけで構成される行を除いたすべての行に共通する、空白またはタブの最長の接頭辞によって決まります（閉じる`"""`を含む行は常に対象になります）。次に、先頭の`"""`の後に続くテキストを除くすべての行から、その共通の接頭辞が削除されます（空白やタブだけの行も、その接頭辞で始まる場合は削除対象です）。たとえば、次のようになります。

```jldoctest
julia> """    This
         is
           a test"""
"    This\nis\n  a test"
```

次に、開始側の`"""`の直後が改行の場合、結果の文字列からその改行が削除されます。

```julia
"""hello"""
```

これは次と同じです。

```julia
"""
hello"""
```

一方、次の場合は

```julia
"""

hello"""
```

文字列の先頭に改行がそのまま含まれます。

改行の削除は、インデントの削除後に行われます。たとえば、次のようになります。

```jldoctest
julia> """
         Hello,
         world."""
"Hello,\nworld."
```

バックスラッシュを使って改行を削除した場合も、インデントは同様に削除されます。

```jldoctest
julia> """
         Averylong\
         word"""
"Averylongword"
```

末尾の空白は変更されません。

三重引用符で囲んだ文字列リテラルには、`"`文字をエスケープせずに含められます。

単一引用符または三重引用符で囲んだ文字列リテラルでは、エディターが行末に復帰文字`\r`（CR）やCRLFの組み合わせを使っていても、リテラル内の改行は文字列中の改行（LF）文字`\n`になります。文字列にCRを含めるには、明示的なエスケープ`\r`を使います。たとえば、文字列リテラル`"a CRLF line ending\r\n"`を入力できます。

## Common Operations

標準の比較演算子を使って、文字列を辞書順で比較できます。

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

[`findfirst`](@ref)関数と[`findlast`](@ref)関数を使うと、特定の文字のインデックスを検索できます。

```jldoctest
julia> findfirst('o', "xylophone")
4

julia> findlast('o', "xylophone")
7

julia> findfirst('z', "xylophone")
```

[`findnext`](@ref)関数と[`findprev`](@ref)関数を使うと、指定した位置から文字の検索を開始できます。

```jldoctest
julia> findnext('o', "xylophone", 1)
4

julia> findnext('o', "xylophone", 5)
7

julia> findprev('o', "xylophone", 5)
4

julia> findnext('o', "xylophone", 8)
```

[`occursin`](@ref)関数を使うと、文字列内に部分文字列が含まれているか確認できます。

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

最後の例から、[`occursin`](@ref)は文字リテラルも検索できることがわかります。

便利な文字列関数として、ほかに[`repeat`](@ref)と[`join`](@ref)があります。

```jldoctest
julia> repeat(".:Z:.", 10)
".:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:."

julia> join(["apples", "bananas", "pineapples"], ", ", " and ")
"apples, bananas and pineapples"
```

ほかにも、次のような便利な関数があります。

  * [`firstindex(str)`](@ref)は、`str`のインデックスとして使える最小の（バイト）インデックスを返します（文字列では常に1ですが、他のコンテナでは必ずしもそうではありません）。
  * [`lastindex(str)`](@ref)は、`str`のインデックスとして使える最大の（バイト）インデックスを返します。
  * [`length(str)`](@ref)は、`str`の文字数を返します。
  * [`length(str, i, j)`](@ref)は、`str`の`i`から`j`までにある、有効な文字インデックスの数を返します。
  * [`ncodeunits(str)`](@ref)は、文字列内の[code units](https://en.wikipedia.org/wiki/Character_encoding#Terminology)の数を返します。
  * [`codeunit(str, i)`](@ref)は、インデックス`i`にある文字列`str`のコード単位値を返します。
  * [`thisind(str, i)`](@ref)は、文字列内の任意のインデックスを受け取り、そのインデックスが指す文字の先頭インデックスを返します。
  * [`nextind(str, i, n=1)`](@ref)は、インデックス`i`の後にある`n`番目の文字の先頭を探します。
  * [`prevind(str, i, n=1)`](@ref)は、インデックス`i`の前にある`n`番目の文字の先頭を探します。

## [Non-Standard String Literals](@id non-standard-string-literals)

文字列を構築したり、文字列の意味論を使ったりしたいものの、標準的な文字列構造では必要な動作が得られない場合があります。そのような場合に備えて、Juliaでは非標準文字列リテラルが用意されています。非標準文字列リテラルは通常の二重引用符付き文字列リテラルに似ていますが、直前に識別子が付き、通常の文字列リテラルとは異なる動作をすることがあります。

以下で説明する[Regular expressions](@ref man-regex-literals)、[byte array literals](@ref man-byte-array-literals)、[version number literals](@ref man-version-number-literals)は、非標準文字列リテラルの例です。ユーザーやパッケージが新しい非標準文字列リテラルを定義することもできます。詳しくは[Metaprogramming](@ref meta-non-standard-string-literals)の節を参照してください。

## [Regular Expressions](@id man-regex-literals)

正確な文字列ではなく、特定の*パターン*を探したい場合もあります。たとえば、大きなテキストファイルから日付を1つ抽出したいとします。探している日付が何かはわかりません（だからこそ検索するのです）が、`YYYY-MM-DD`のような形式になることはわかっています。正規表現を使うと、このようなパターンを指定して検索できます。

Juliaは、[PCRE](https://www.pcre.org/)ライブラリが提供するPerl互換正規表現（regex）のバージョン2を使います（詳しくは[PCRE2 syntax description](https://www.pcre.org/current/doc/html/pcre2syntax.html)を参照してください）。正規表現と文字列には2つの関係があります。1つは、文字列内の規則的なパターンを見つけるために正規表現を使うという明白な関係です。もう1つは、正規表現自体も文字列として入力され、文字列内のパターンを効率よく検索するための状態機械に解析されるという関係です。Juliaでは、`r`で始まるさまざまな識別子を前置した非標準文字列リテラルを使って正規表現を入力します。オプションを指定しない最も基本的な正規表現リテラルでは、`r"..."`だけを使います。

```jldoctest
julia> re = r"^\s*(?:#|$)"
r"^\s*(?:#|$)"

julia> typeof(re)
Regex
```

正規表現が文字列にマッチするか確認するには、[`occursin`](@ref)を使います。

```jldoctest
julia> occursin(r"^\s*(?:#|$)", "not a comment")
false

julia> occursin(r"^\s*(?:#|$)", "# a comment")
true
```

この例からわかるように、[`occursin`](@ref)は、指定した正規表現にマッチするものが文字列内にあるかどうかを示すtrueまたはfalseを返すだけです。しかし多くの場合、文字列がマッチしたかどうかだけでなく、*どのように*マッチしたかも知りたいでしょう。マッチに関する情報を取得するには、代わりに[`match`](@ref)関数を使います。

```jldoctest
julia> match(r"^\s*(?:#|$)", "not a comment")

julia> match(r"^\s*(?:#|$)", "# a comment")
RegexMatch("#")
```

正規表現が指定した文字列にマッチしない場合、[`match`](@ref)は[`nothing`](@ref)を返します。これは対話プロンプトでは何も表示されない特殊な値です。表示されないことを除けば通常の値なので、プログラムから検査できます。

```julia
m = match(r"^\s*(?:#|$)", line)
if m === nothing
    println("not a comment")
else
    println("blank or comment")
end
```

正規表現がマッチした場合、[`match`](@ref)が返す値は[`RegexMatch`](@ref)オブジェクトです。このオブジェクトには、パターンにマッチした部分文字列や、キャプチャされた部分文字列があればその内容など、式がどのようにマッチしたかが記録されます。この例ではマッチした部分だけをキャプチャしていますが、コメント文字の後にある空白以外のテキストもキャプチャしたい場合があります。その場合は、次のようにします。

```jldoctest
julia> m = match(r"^\s*(?:#\s*(.*?)\s*$)", "# a comment ")
RegexMatch("# a comment ", 1="a comment")
```

[`match`](@ref)を呼び出す際に、検索を開始するインデックスを指定できます。たとえば、次のようになります。

```jldoctest
julia> m = match(r"[0-9]","aaaa1aaaa2aaaa3",1)
RegexMatch("1")

julia> m = match(r"[0-9]","aaaa1aaaa2aaaa3",6)
RegexMatch("2")

julia> m = match(r"[0-9]","aaaa1aaaa2aaaa3",11)
RegexMatch("3")
```

`RegexMatch`オブジェクトからは、次の情報を取り出せます。

  * マッチした部分文字列全体：`m.match`
  * キャプチャされた部分文字列の配列：`m.captures`
  * マッチ全体が始まるオフセット：`m.offset`
  * キャプチャされた部分文字列のオフセットを格納したベクトル：`m.offsets`

キャプチャがマッチしなかった場合、その位置の`m.captures`には部分文字列ではなく`nothing`が入り、`m.offsets`のオフセットは0になります（Juliaのインデックスは1始まりなので、文字列内のオフセット0は無効です）。少し作為的な例を2つ示します。

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

キャプチャが配列として返されると、分割代入構文を使ってローカル変数に割り当てられるので便利です。さらに、`RegexMatch`オブジェクトは、`captures`フィールドをそのまま反復するイテレーター用メソッドを実装しています。そのため、マッチオブジェクトを直接分割代入できます。

```jldoctest acdmatch
julia> first, second, third = m; first
"a"
```

キャプチャは、`RegexMatch`オブジェクトをキャプチャグループの番号または名前でインデックス指定して取得することもできます。

```jldoctest
julia> m=match(r"(?<hour>\d+):(?<minute>\d+)","12:45")
RegexMatch("12:45", hour="12", minute="45")

julia> m[:minute]
"45"

julia> m[2]
"45"
```

[`replace`](@ref)を使う際、置換文字列内でキャプチャを参照するには、`\n`に続けてキャプチャグループの番号を指定し、置換文字列の前に`s`を付けます。キャプチャグループ0はマッチオブジェクト全体を指します。名前付きキャプチャグループは、置換文字列内で`\g<groupname>`を使って参照できます。たとえば、次のようになります。

```jldoctest
julia> replace("first second", r"(\w+) (?<agroup>\w+)" => s"\g<agroup> \1")
"second first"
```

番号付きキャプチャグループは、曖昧さを避けるために`\g<n>`として参照することもできます。たとえば、次のようになります。

```jldoctest
julia> replace("a", r"." => s"\g<0>1")
"a1"
```

閉じる二重引用符の後に`i`、`m`、`s`、`x`のフラグを組み合わせて指定すると、正規表現の動作を変更できます。これらのフラグの意味はPerlと同じです。詳しくは、[perlre manpage](https://perldoc.perl.org/perlre#Modifiers)からの抜粋を参照してください。

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

たとえば、次の正規表現では3つのフラグすべてが有効になっています。

```jldoctest
julia> r"a+.*b+.*d$"ism
r"a+.*b+.*d$"ims

julia> match(r"a+.*b+.*d$"ism, "Goodbye,\nOh, angry,\nBad world\n")
RegexMatch("angry,\nBad world")
```

`r"..."`リテラルは、補間もアンエスケープも行わずに構築されます（ただし、引用符`"`は引き続きエスケープが必要です）。標準的な文字列リテラルとの違いを示す例を次に示します。

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

`r"""..."""`形式の三重引用符付き正規表現文字列もサポートされています（引用符や改行を含む正規表現では便利な場合があります）。

`Regex()`コンストラクターを使うと、有効な正規表現文字列をプログラムから作成できます。これにより、文字列変数の内容やその他の文字列操作を使って正規表現文字列を構築できます。上記の正規表現コードは、いずれも`Regex()`の単一の文字列引数内で使用できます。例をいくつか示します。

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

`\Q...\E`エスケープシーケンスの使い方に注目してください。`\Q`と`\E`の間にある文字はすべて、リテラル文字として解釈されます。これは、通常なら正規表現のメタ文字となる文字を照合する際に便利です。ただし、この機能を文字列補間と併用する場合は注意が必要です。補間された文字列自体に`\E`が含まれていると、意図せずリテラル照合が終了することがあります。正規表現に含める前に、ユーザー入力をサニタイズする必要があります。

## [Byte Array Literals](@id man-byte-array-literals)

もう1つ便利な非標準文字列リテラルに、バイト配列文字列リテラル`b"..."`があります。この形式では、文字列の表記を使って読み取り専用のリテラルバイト配列、つまり[`UInt8`](@ref)値の配列を記述できます。これらのオブジェクトの型は`CodeUnits{UInt8, String}`です。バイト配列リテラルの規則は次のとおりです。

  * ASCII文字とASCIIエスケープは、それぞれ1バイトを生成します。
  * `\x`と8進エスケープシーケンスは、エスケープ値に対応する*バイト*を生成します。
  * Unicodeエスケープシーケンスは、そのコードポイントをUTF-8でエンコードしたバイト列を生成します。

これらの規則には一部重複があります。`\x`と0x80（128）未満の8進エスケープの動作は、最初の2つの規則の両方に当てはまりますが、どちらの規則でも結果は同じです。これらの規則を組み合わせることで、ASCII文字、任意のバイト値、UTF-8シーケンスを使って、簡単にバイト配列を作成できます。3種類すべてを使った例を示します。

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

ASCII文字列「DATA」は、バイト68、65、84、65に対応します。`\xff`は単一のバイト255を生成します。Unicodeエスケープ`\u2200`は、UTF-8では3バイト226、136、128にエンコードされます。結果のバイト配列は、有効なUTF-8文字列に対応しないことに注意してください。

```jldoctest
julia> isvalid("DATA\xff\u2200")
false
```

前述のとおり、`CodeUnits{UInt8, String}`型は`UInt8`の読み取り専用配列のように動作します。標準的なベクトルが必要な場合は、`Vector{UInt8}`を使って変換できます。

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

`\xff`と`\uff`の重要な違いにも注意してください。前者のエスケープシーケンスは*バイト255*をエンコードしますが、後者は*コードポイント255*を表し、UTF-8では2バイトにエンコードされます。

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

`\u80`未満のコードポイントでは、各コードポイントのUTF-8エンコーディングが、対応する`\x`エスケープで生成される単一バイトと一致します。そのため、この範囲では両者の違いを無視しても問題ありません。しかし、`\x80`から`\xff`までのエスケープと、`\u80`から`\uff`までのエスケープには大きな違いがあります。前者はすべて単一バイトをエンコードするため、特定の継続バイトが後に続かない限り、有効なUTF-8データにはなりません。一方、後者はすべて、2バイトでエンコードされるUnicodeコードポイントを表します。

これが非常にわかりにくい場合は、["The Absolute Minimum Every Software Developer Absolutely, Positively Must Know About Unicode and Character Sets"](https://www.joelonsoftware.com/2003/10/08/the-absolute-minimum-every-software-developer-absolutely-positively-must-know-about-unicode-and-character-sets-no-excuses/)を読んでみてください。UnicodeとUTF-8についての優れた入門資料で、この問題に関する混乱を解消する助けになるでしょう。

## [Version Number Literals](@id man-version-number-literals)

バージョン番号は、[`v"..."`](@ref @v_str)形式の非標準文字列リテラルで簡単に表せます。バージョン番号リテラルは、[semantic versioning 2.0.0-rc2](https://semver.org/spec/v2.0.0-rc.2.html)の仕様に従う[`VersionNumber`](@ref)オブジェクトを作成します。これらは、メジャー、マイナー、パッチの各数値と、それに続くプレリリースおよびビルドの英数字注釈で構成されます。たとえば、`v"0.2.1-rc1+win64"`は、メジャーバージョン`0`、マイナーバージョン`2`、パッチバージョン`1`、プレリリース`rc1`、ビルド`win64`に分解されます。バージョンリテラルでは、メジャーバージョン番号以外はすべて省略できます。したがって、たとえば`v"0.2"`は`v"0.2.0"`（プレリリースとビルドの注釈が空）と同じであり、`v"2"`は`v"2.0.0"`と同じです。

`VersionNumber`オブジェクトは、2つ以上のバージョンを簡単かつ正確に比較するのに特に便利です。たとえば、定数[`VERSION`](@ref)にはJuliaのバージョン番号が`VersionNumber`オブジェクトとして格納されているため、次のような簡単な文でバージョンごとの動作を定義できます。

```julia
if v"0.2" <= VERSION < v"0.3-"
    # do something specific to 0.2 release series
end
```

上の例では、末尾に`-`を付けた非標準のバージョン番号`v"0.3-"`を使っています。この表記はJuliaによる規格の拡張であり、すべてのプレリリースを含む、あらゆる`0.3`リリースよりも小さいバージョンを表します。そのため、上の例のコードは安定版の`0.2`でのみ実行され、`v"0.3.0-rc1"`などのバージョンは対象外になります。不安定版（つまりプレリリース）の`0.2`も許可するには、下限のチェックを次のように変更します。`v"0.2-" <= VERSION`

バージョン指定に関するもう1つの非標準拡張では、末尾に`+`を付けて、ビルドバージョンの上限を表せます。たとえば、`VERSION > v"0.2-rc1+"`は、`0.2-rc1`およびそのすべてのビルドより上の任意のバージョンを表します。この指定は、バージョン`v"0.2-rc1+win64"`に対して`false`を返し、`v"0.2-rc2"`に対して`true`を返します。

比較では、このような特殊なバージョンを使うのが望ましい方法です（特に、正当な理由がない限り、上限には末尾の`-`を必ず使ってください）。ただし、セマンティックバージョニングの規則では無効なため、実際のバージョン番号として使ってはいけません。

[`VERSION`](@ref)定数に使われるほか、`VersionNumber`オブジェクトは`Pkg`モジュールでも広く使われ、パッケージのバージョンや依存関係を指定します。

## [Raw String Literals](@id man-raw-string-literals)

補間やアンエスケープを行わない生の文字列は、`raw"..."`形式の非標準文字列リテラルで表せます。生文字列リテラルは通常の`String`オブジェクトを作成し、囲まれた内容を入力どおりに保持します。補間もアンエスケープも行われません。これは、`$`や`\`を特殊文字として使う他の言語のコードやマークアップを含む文字列に便利です。

ただし、引用符は引き続きエスケープする必要があります。たとえば、`raw"\""`は`"\""`と同じです。あらゆる文字列を表現できるようにするため、引用符の直前にある場合に限り、バックスラッシュもエスケープする必要があります。

```jldoctest
julia> println(raw"\\ \\\"")
\\ \"
```

最初の2つのバックスラッシュは引用符の直前にないため、出力にそのまま現れることに注意してください。一方、次のバックスラッシュは後続のバックスラッシュをエスケープし、最後のバックスラッシュは引用符をエスケープします。これらのバックスラッシュは引用符の前にあるためです。

## [Annotated Strings](@id man-annotated-strings)

!!! note
    AnnotatedStringsのAPIは実験的なものとみなされており、Juliaのバージョン間で変更される可能性があります。


文字列の一部の領域に関連するメタデータを保持したい場合があります。[`AnnotatedString`](@ref Base.AnnotatedString)は別の文字列をラップし、その領域にラベル付きの値（`:label => value`）を付与できます。一般的な文字列操作はすべて、基になる文字列に対して適用されます。ただし、可能な場合はスタイル情報が保持されます。つまり、[`AnnotatedString`](@ref Base.AnnotatedString)に対して部分文字列の取得、パディング、他の文字列との連結などを行っても、メタデータの注釈はそのまま引き継がれます。

この文字列型は[StyledStrings stdlib](@ref stdlib-styledstrings)の基盤となっており、`:face`ラベル付きの注釈を使ってスタイル情報を保持します。

[`AnnotatedString`](@ref Base.AnnotatedString)を連結する際、文字列の注釈を保持したい場合は、[`string`](@ref)ではなく[`annotatedstring`](@ref Base.annotatedstring)を使ってください。

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

[`AnnotatedString`](@ref Base.AnnotatedString)の注釈は、[`annotations`](@ref Base.annotations)関数と[`annotate!`](@ref Base.annotate!)関数を使って取得・変更できます。
