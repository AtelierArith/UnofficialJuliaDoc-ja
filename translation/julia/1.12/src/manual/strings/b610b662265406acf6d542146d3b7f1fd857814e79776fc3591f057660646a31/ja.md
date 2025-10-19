# [Strings](@id man-strings)

文字列は有限の文字の列です。もちろん、実際の問題は「文字とは何か」と尋ねるときに発生します。英語を話す人々が馴染みのある文字は、`A`、`B`、`C`などのアルファベット、数字、一般的な句読点記号です。これらの文字は、[ASCII](https://en.wikipedia.org/wiki/ASCII)標準によって、0から127の間の整数値へのマッピングと共に標準化されています。もちろん、アクセントやその他の修正を加えたASCII文字のバリエーション、キリル文字やギリシャ文字などの関連スクリプト、アラビア語、中国語、ヘブライ語、ヒンディー語、日本語、韓国語など、ASCIIや英語とは完全に無関係なスクリプトを含む、他の多くの文字が非英語の言語で使用されています。[Unicode](https://en.wikipedia.org/wiki/Unicode)標準は、文字とは正確に何かという複雑さに対処し、この問題に対処するための決定的な標準として一般的に受け入れられています。ニーズに応じて、これらの複雑さを完全に無視してASCII文字のみが存在するふりをすることも、非ASCIIテキストを扱う際に遭遇する可能性のある任意の文字やエンコーディングを処理できるコードを書くこともできます。Juliaは、プレーンなASCIIテキストの取り扱いをシンプルかつ効率的にし、Unicodeの処理もできる限りシンプルかつ効率的です。特に、Cスタイルの文字列コードを書いてASCII文字列を処理することができ、パフォーマンスとセマンティクスの両方の観点から期待通りに動作します。そのようなコードが非ASCIIテキストに遭遇した場合、明確なエラーメッセージで優雅に失敗し、静かに破損した結果を導入することはありません。このような場合、非ASCIIデータを処理するようにコードを修正するのは簡単です。

Juliaの文字列にはいくつかの注目すべき高レベルの特徴があります：

  * Juliaで文字列（および文字列リテラル）に使用される組み込みのコンクリート型は [`String`](@ref) です。これは、[Unicode](https://en.wikipedia.org/wiki/Unicode) 文字の全範囲を [UTF-8](https://en.wikipedia.org/wiki/UTF-8) エンコーディングを介してサポートします。（他のUnicodeエンコーディングへの変換を行うための [`transcode`](@ref) 関数が提供されています。）
  * すべての文字列型は抽象型 `AbstractString` のサブタイプであり、外部パッケージは追加の `AbstractString` サブタイプを定義します（例えば、他のエンコーディング用）。文字列引数を期待する関数を定義する場合は、任意の文字列型を受け入れるために型を `AbstractString` として宣言するべきです。
  * CやJavaと同様に、ほとんどの動的言語とは異なり、Juliaには単一の文字を表すためのファーストクラスの型があり、[`AbstractChar`](@ref)と呼ばれています。組み込みの[`Char`](@ref)は、`AbstractChar`のサブタイプであり、任意のUnicode文字を表すことができる32ビットのプリミティブ型です（これはUTF-8エンコーディングに基づいています）。
  * Javaのように、文字列は不変です：`AbstractString`オブジェクトの値は変更できません。異なる文字列値を構築するには、他の文字列の部分から新しい文字列を構築します。
  * 概念的には、文字列はインデックスから文字への*部分関数*です：いくつかのインデックス値に対して、文字値が返されず、代わりに例外がスローされます。これにより、Unicode文字列の可変幅エンコーディングに対して効率的かつ単純に実装できない文字インデックスではなく、エンコードされた表現のバイトインデックスによる文字列への効率的なインデックス付けが可能になります。

## [Characters](@id man-characters)

`Char` 値は単一の文字を表します：これは特別なリテラル表現と適切な算術動作を持つ32ビットのプリミティブ型であり、[Unicode code point](https://en.wikipedia.org/wiki/Code_point) を表す数値に変換することができます。 （Julia パッケージは、他の [text encodings](https://en.wikipedia.org/wiki/Character_encoding) の操作を最適化するために、`AbstractChar` の他のサブタイプを定義することがあります。）ここでは、`Char` 値の入力と表示の方法を示します（文字リテラルは二重引用符ではなく単一引用符で区切られていることに注意してください）：

```jldoctest
julia> c = 'x'
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)

julia> typeof(c)
Char
```

`Char`を簡単に整数値、つまりコードポイントに変換できます：

```jldoctest
julia> c = Int('x')
120

julia> typeof(c)
Int64
```

32ビットアーキテクチャでは、[`typeof(c)`](@ref) は [`Int32`](@ref) になります。整数値を `Char` に戻すのも同じくらい簡単です：

```jldoctest
julia> Char(120)
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)
```

すべての整数値が有効なUnicodeコードポイントであるわけではありませんが、パフォーマンスのために、`Char`変換はすべての文字値が有効であるかどうかをチェックしません。変換された各値が有効なコードポイントであることを確認したい場合は、[`isvalid`](@ref)関数を使用してください：

```jldoctest
julia> Char(0x110000)
'\U110000': Unicode U+110000 (category In: Invalid, too high)

julia> isvalid(Char, 0x110000)
false
```

この執筆時点で、有効なUnicodeコードポイントは `U+0000` から `U+D7FF` までと `U+E000` から `U+10FFFF` までです。これらはまだすべて理解可能な意味が割り当てられているわけではなく、アプリケーションによって解釈されるとは限りませんが、これらの値はすべて有効なUnicode文字と見なされています。

単一引用符内に任意のUnicode文字を入力するには、`\u`の後に最大4桁の16進数を続けるか、`\U`の後に最大8桁の16進数を続けます（最も長い有効な値は6桁のみを必要とします）：

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

Juliaは、システムのロケールと言語設定を使用して、どの文字をそのまま出力できるか、どの文字を一般的なエスケープ形式の `\u` または `\U` で出力する必要があるかを判断します。これらのUnicodeエスケープ形式に加えて、すべての [C's traditional escaped input forms](https://en.wikipedia.org/wiki/C_syntax#Backslash_escapes) も使用できます：

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

`Char` 値を使って比較や限られた量の算術を行うことができます:

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

文字列リテラルは、二重引用符または三重の二重引用符（単一引用符ではなく）で区切られます：

```jldoctest helloworldstring
julia> str = "Hello, world.\n"
"Hello, world.\n"

julia> """Contains "quote" characters"""
"Contains \"quote\" characters"
```

文字列内の長い行は、改行の前にバックスラッシュ（`\`）を置くことで分割できます：

```jldoctest
julia> "This is a long \
       line"
"This is a long line"
```

文字列から文字を抽出したい場合は、インデックスを使用します：

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

多くのJuliaオブジェクト、特に文字列は、整数でインデックス付けすることができます。最初の要素（文字列の最初の文字）のインデックスは [`firstindex(str)`](@ref) で返され、最後の要素（文字）のインデックスは [`lastindex(str)`](@ref) で返されます。キーワード `begin` と `end` は、指定された次元に沿った最初と最後のインデックスの省略形として、インデックス操作内で使用できます。文字列のインデックス付けは、Juliaのほとんどのインデックス付けと同様に1ベースです： `firstindex` は常に任意の `AbstractString` に対して `1` を返します。しかし、以下で見るように、 `lastindex(str)` は一般的には文字列の `length(str)` と同じではありません。なぜなら、一部のUnicode文字は複数の「コードユニット」を占有することがあるからです。

[`end`](@ref)を通常の値のように、算術演算やその他の操作を行うことができます:

```jldoctest helloworldstring
julia> str[end-1]
'.': ASCII/Unicode U+002E (category Po: Punctuation, other)

julia> str[end÷2]
' ': ASCII/Unicode U+0020 (category Zs: Separator, space)
```

`begin`（`1`）より小さいインデックスまたは`end`より大きいインデックスを使用すると、エラーが発生します：

```jldoctest helloworldstring
julia> str[begin-1]
ERROR: BoundsError: attempt to access 14-codeunit String at index [0]
[...]

julia> str[end+1]
ERROR: BoundsError: attempt to access 14-codeunit String at index [15]
[...]
```

範囲インデックスを使用して部分文字列を抽出することもできます：

```jldoctest helloworldstring
julia> str[4:9]
"lo, wo"
```

`str[k]` と `str[k:k]` の表現は同じ結果を返さないことに注意してください：

```jldoctest helloworldstring
julia> str[6]
',': ASCII/Unicode U+002C (category Po: Punctuation, other)

julia> str[6:6]
","
```

前者は`Char`型の単一文字の値であり、後者は単一の文字のみを含む文字列の値です。Juliaでは、これらは非常に異なるものです。

範囲インデックスは、元の文字列の選択された部分のコピーを作成します。代わりに、[`SubString`](@ref) 型を使用して文字列へのビューを作成することが可能です。より簡単には、コードのブロック上で [`@views`](@ref) マクロを使用すると、すべての文字列スライスがサブストリングに変換されます。例えば：

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

いくつかの標準関数、例えば [`chop`](@ref)、[`chomp`](@ref) または [`strip`](@ref) は、[`SubString`](@ref) を返します。

## Unicode and UTF-8

JuliaはUnicode文字と文字列を完全にサポートしています。[discussed above](@ref man-characters)のように、文字リテラルでは、UnicodeコードポイントをUnicode `\u`および`\U`エスケープシーケンスを使用して表現できます。また、すべての標準Cエスケープシーケンスも使用できます。これらは文字列リテラルを書くためにも同様に使用できます：

```jldoctest unicodestring
julia> s = "\u2200 x \u2203 y"
"∀ x ∃ y"
```

これらのUnicode文字がエスケープとして表示されるか、特別な文字として表示されるかは、ターミナルのロケール設定とUnicodeのサポートに依存します。文字列リテラルはUTF-8エンコーディングを使用してエンコードされます。UTF-8は可変幅エンコーディングであり、すべての文字が同じバイト数（「コードユニット」）でエンコードされるわけではありません。UTF-8では、ASCII文字 — つまり、コードポイントが0x80（128）未満の文字は、ASCIIと同様に単一バイトでエンコードされ、コードポイント0x80以上の文字は複数バイト（最大4バイト）でエンコードされます。

Juliaの文字列のインデックスは、任意の文字（コードポイント）をエンコードするために使用される固定幅のビルディングブロック（UTF-8の場合はバイト）であるコードユニットを指します。これは、`String`へのすべてのインデックスが必ずしも文字の有効なインデックスであるとは限らないことを意味します。無効なバイトインデックスで文字列にインデックスを付けると、エラーが発生します：

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

この場合、文字 `∀` は3バイトの文字であるため、インデックス2と3は無効であり、次の文字のインデックスは4です。この次の有効なインデックスは [`nextind(s,1)`](@ref) によって計算できます。そして、その次のインデックスは `nextind(s,4)` によって計算されます。

`end`は常にコレクション内の最後の有効なインデックスであるため、`end-1`は、最後から2番目の文字がマルチバイトの場合、無効なバイトインデックスを参照します。

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

最初のケースは機能します。なぜなら、最後の文字 `y` とスペースは1バイトの文字であり、一方で `end-2` は `∃` のマルチバイト表現の中間にインデックスを指定するからです。このケースの正しい方法は `prevind(s, lastindex(s), 2)` を使用するか、もしその値を `s` にインデックスするために使用する場合は `s[prevind(s, end, 2)]` と書くことができ、`end` は `lastindex(s)` に展開されます。

範囲インデックスを使用した部分文字列の抽出は、有効なバイトインデックスを期待し、そうでない場合はエラーがスローされます:

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

可変長エンコーディングのため、文字列の文字数（[`length(s)`](@ref) で示される）は、常に最後のインデックスと同じではありません。インデックス 1 から [`lastindex(s)`](@ref) を反復処理し、`s` にインデックスを付けると、エラーが発生しない場合に返される文字のシーケンスは、文字列 `s` を構成する文字のシーケンスです。したがって、`length(s) <= lastindex(s)` です。文字列の各文字には独自のインデックスが必要です。以下は、`s` の文字を反復処理する非効率的で冗長な方法です：

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

空白行には実際にスペースがあります。幸いなことに、上記の不自然なイディオムは文字列内の文字を反復処理するためには不要です。文字列を反復可能なオブジェクトとしてそのまま使用でき、例外処理は必要ありません。

```jldoctest unicodestring
julia> for c in s
           println(c)
       end
∀

x

∃

y
```

文字列の有効なインデックスを取得する必要がある場合は、上記で述べたように、[`nextind`](@ref) および [`prevind`](@ref) 関数を使用して、次の/前の有効なインデックスにインクリメント/デクリメントできます。また、[`eachindex`](@ref) 関数を使用して、有効な文字インデックスを反復処理することもできます。

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

生のコードユニット（UTF-8のバイト）にアクセスするには、[`codeunit(s,i)`](@ref) 関数を使用できます。このとき、インデックス `i` は `1` から [`ncodeunits(s)`](@ref) まで連続して実行されます。[`codeunits(s)`](@ref) 関数は、これらの生のコードユニット（バイト）に配列としてアクセスできる `AbstractVector{UInt8}` ラッパーを返します。

Juliaの文字列は、無効なUTF-8コードユニットシーケンスを含むことができます。この規則により、任意のバイトシーケンスを`String`として扱うことができます。このような状況では、左から右にコードユニットのシーケンスを解析する際のルールは、次のビットパターンのいずれかの先頭に一致する最長の8ビットコードユニットのシーケンスによって文字が形成されるというものです（各`x`は`0`または`1`にできます）：

  * `0xxxxxxx`;
  * `110xxxxx` `10xxxxxx`;
  * `1110xxxx` `10xxxxxx` `10xxxxxx`;
  * `11110xxx` `10xxxxxx` `10xxxxxx` `10xxxxxx`;
  * `10xxxxxx`;
  * `11111xxx`.

特に、これは長すぎるおよび高すぎるコードユニットシーケンスとその接頭辞が、複数の無効な文字ではなく、単一の無効な文字として扱われることを意味します。このルールは、例を用いて説明するのが最適かもしれません：

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

文字列 `s` の最初の2つのコードユニットは、スペース文字のオーバーロングエンコーディングを形成しています。これは無効ですが、文字列内では単一の文字として受け入れられます。次の2つのコードユニットは、3バイトのUTF-8シーケンスの有効な開始を形成します。しかし、5番目のコードユニット `\xe2` はその有効な継続ではありません。したがって、コードユニット3と4もこの文字列内で不正な文字として解釈されます。同様に、コードユニット5は不正な文字を形成します。なぜなら、`|` はそれに対する有効な継続ではないからです。最後に、文字列 `s2` には1つ高すぎるコードポイントが含まれています。

JuliaはデフォルトでUTF-8エンコーディングを使用しており、新しいエンコーディングのサポートはパッケージによって追加できます。例えば、[LegacyStrings.jl](https://github.com/JuliaStrings/LegacyStrings.jl)パッケージは`UTF16String`および`UTF32String`タイプを実装しています。他のエンコーディングに関する追加の議論や、それらのサポートを実装する方法については、現時点ではこの文書の範囲を超えています。UTF-8エンコーディングの問題についてのさらなる議論は、[byte array literals](@ref man-byte-array-literals)に関する下のセクションを参照してください。[`transcode`](@ref)関数は、主に外部データやライブラリと作業するために、さまざまなUTF-xxエンコーディング間でデータを変換するために提供されています。

## [Concatenation](@id man-concatenation)

最も一般的で便利な文字列操作の1つは、連結です：

```jldoctest stringconcat
julia> greet = "Hello"
"Hello"

julia> whom = "world"
"world"

julia> string(greet, ", ", whom, ".\n")
"Hello, world.\n"
```

危険な状況、例えば無効なUTF-8文字列の連結に注意することが重要です。結果として得られる文字列は、入力文字列とは異なる文字を含む可能性があり、その文字数は連結された文字列の文字数の合計よりも少なくなる場合があります。例えば：

```julia-repl
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

この状況は無効なUTF-8文字列にのみ発生する可能性があります。有効なUTF-8文字列の場合、連結は文字列内のすべての文字を保持し、文字列の長さの加算性を保ちます。

Juliaは文字列の連結のために[`*`](@ref)も提供しています：

```jldoctest stringconcat
julia> greet * ", " * whom * ".\n"
"Hello, world.\n"
```

`*`は、文字列の連結に`+`を提供する言語のユーザーにとって驚くべき選択のように思えるかもしれませんが、この`*`の使用は数学、特に抽象代数において前例があります。

数学において、`+` は通常 *可換* 演算を示し、オペランドの順序は重要ではありません。これの例は行列の加算であり、同じ形状の任意の行列 `A` と `B` に対して `A + B == B + A` となります。対照的に、`*` は通常 *非可換* 演算を示し、オペランドの順序は *重要* です。これの例は行列の乗算であり、一般に `A * B != B * A` となります。行列の乗算と同様に、文字列の連結も非可換です：`greet * whom != whom * greet`。したがって、`*` は一般的な数学的使用に一致した中置文字列連結演算子としてより自然な選択です。

より正確には、すべての有限長文字列の集合 *S* と文字列連結演算子 `*` は [free monoid](https://en.wikipedia.org/wiki/Free_monoid) (*S*, `*`) を形成します。この集合の単位元は空文字列 `""` です。自由モノイドが可換でない場合、演算は通常 `\cdot`、`*`、または類似の記号で表され、`+` は通常可換性を示唆するため、使用されません。

## [Interpolation](@id string-interpolation)

文字列を連結して構築するのは少し面倒になることがあります。しかし、[`string`](@ref)のような冗長な呼び出しや繰り返しの乗算の必要性を減らすために、JuliaはPerlのように`$`を使って文字列リテラルに補間を許可しています。

```jldoctest
julia> greet = "Hello"; whom = "world";

julia> "$greet, $whom.\n"
"Hello, world.\n"
```

これは、上記の文字列連結と同等であり、より読みやすく便利です。システムは、この明らかな単一の文字列リテラルを呼び出し `string(greet, ", ", whom, ".\n")` に書き換えます。

`$`の後の最短の完全な式は、文字列に補間される値を持つ式として取られます。したがって、括弧を使用して文字列に任意の式を補間することができます：

```jldoctest
julia> "1 + 2 = $(1 + 2)"
"1 + 2 = 3"
```

両方の連結と文字列補間は [`string`](@ref) を呼び出してオブジェクトを文字列形式に変換します。しかし、`string` は実際には [`print`](@ref) の出力を返すだけなので、新しい型は `4d61726b646f776e2e436f64652822222c20227072696e742229_40726566` または [`show`](@ref) にメソッドを追加するべきです。

ほとんどの非`AbstractString`オブジェクトは、リテラル式として入力された方法に密接に対応する文字列に変換されます：

```jldoctest
julia> v = [1,2,3]
3-element Vector{Int64}:
 1
 2
 3

julia> "v: $v"
"v: [1, 2, 3]"
```

[`string`](@ref) は `AbstractString` と `AbstractChar` の値のアイデンティティであるため、これらは文字列にそのまま、引用符なしでエスケープなしで補間されます：

```jldoctest
julia> c = 'x'
'x': ASCII/Unicode U+0078 (category Ll: Letter, lowercase)

julia> "hi, $c"
"hi, x"
```

文字列リテラルにリテラルの `$` を含めるには、バックスラッシュでエスケープします:

```jldoctest
julia> print("I have \$100 in my account.\n")
I have $100 in my account.
```

## Triple-Quoted String Literals

三重引用符（`"""..."""`）を使用して文字列が作成されると、長いテキストブロックを作成するのに便利な特別な動作があります。

最初に、三重引用符で囲まれた文字列は、最もインデントが少ない行のレベルに合わせてインデントが解除されます。これは、インデントされたコード内で文字列を定義する際に便利です。例えば：

```jldoctest
julia> str = """
           Hello,
           world.
         """
"  Hello,\n  world.\n"
```

この場合、閉じる `"""` の前の最終行（空行）がインデントレベルを設定します。

インデントレベルは、すべての行におけるスペースまたはタブの最長の共通の開始シーケンスによって決定されます。これは、開く `"""` の後に続く行や、スペースまたはタブのみを含む行を除外します（閉じる `"""` を含む行は常に含まれます）。次に、開く `"""` の後のテキストを除くすべての行から、共通の開始シーケンスが削除されます（このシーケンスで始まるスペースやタブのみを含む行も含まれます）。例えば：

```jldoctest
julia> """    This
         is
           a test"""
"    This\nis\n  a test"
```

次に、開きの `"""` の後に改行が続く場合、その改行は結果の文字列から削除されます。

```julia
"""hello"""
```

は等しいです

```julia
"""
hello"""
```

しかし

```julia
"""

hello"""
```

最初にリテラルな改行が含まれます。

インデント解除の後に改行の削除が行われます。例えば：

```jldoctest
julia> """
         Hello,
         world."""
"Hello,\nworld."
```

改行がバックスラッシュを使って削除されると、インデントの解除も尊重されます:

```jldoctest
julia> """
         Averylong\
         word"""
"Averylongword"
```

トレーリングホワイトスペースはそのまま残されます。

三重引用符の文字列リテラルは、エスケープせずに `"` 文字を含むことができます。

リテラル文字列内の改行は、シングルクォートまたはトリプルクォートのいずれであっても、文字列内に改行（LF）文字 `\n` を生成します。たとえエディタがキャリッジリターン `\r`（CR）またはCRLFの組み合わせを使用して行を終了させていてもです。文字列にCRを含めるには、明示的なエスケープ `\r` を使用します。たとえば、リテラル文字列 `"a CRLF line ending\r\n"` を入力できます。

## Common Operations

文字列は標準の比較演算子を使用して辞書式に比較できます：

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

特定の文字のインデックスを検索するには、[`findfirst`](@ref) および [`findlast`](@ref) 関数を使用できます：

```jldoctest
julia> findfirst('o', "xylophone")
4

julia> findlast('o', "xylophone")
7

julia> findfirst('z', "xylophone")
```

指定されたオフセットで文字を検索するには、関数 [`findnext`](@ref) と [`findprev`](@ref) を使用します:

```jldoctest
julia> findnext('o', "xylophone", 1)
4

julia> findnext('o', "xylophone", 5)
7

julia> findprev('o', "xylophone", 5)
4

julia> findnext('o', "xylophone", 8)
```

[`occursin`](@ref) 関数を使用して、文字列内に部分文字列が存在するかどうかを確認できます：

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

最後の例は、[`occursin`](@ref) が文字リテラルを探すこともできることを示しています。

他の便利な文字列関数は [`repeat`](@ref) と [`join`](@ref) です:

```jldoctest
julia> repeat(".:Z:.", 10)
".:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:..:Z:."

julia> join(["apples", "bananas", "pineapples"], ", ", " and ")
"apples, bananas and pineapples"
```

他のいくつかの便利な関数には次のものが含まれます：

  * [`firstindex(str)`](@ref) は、`str` にインデックスを付けるために使用できる最小の（バイト）インデックスを提供します（文字列の場合は常に 1 ですが、他のコンテナに対しては必ずしもそうではありません）。
  * [`lastindex(str)`](@ref) は、`str` にインデックスを付けるために使用できる最大の (バイト) インデックスを提供します。
  * [`length(str)`](@ref) の `str` の文字数。
  * [`length(str, i, j)`](@ref) の `str` の中で `i` から `j` までの有効な文字インデックスの数。
  * [`ncodeunits(str)`](@ref) の数は [code units](https://en.wikipedia.org/wiki/Character_encoding#Terminology) の文字列に含まれています。
  * [`codeunit(str, i)`](@ref) は、文字列 `str` のインデックス `i` におけるコードユニット値を返します。
  * [`thisind(str, i)`](@ref) という文字列において、任意のインデックスからそのインデックスが指す文字の最初のインデックスを見つけます。
  * [`nextind(str, i, n=1)`](@ref) の `i` インデックスの後から `n` 番目の文字の開始位置を見つけます。
  * [`prevind(str, i, n=1)`](@ref) の `i` インデックスの前から `n` 番目の文字の開始位置を見つけます。

## [Non-Standard String Literals](@id non-standard-string-literals)

文字列を構築したり、文字列のセマンティクスを使用したりしたい状況がありますが、標準の文字列構築の動作が必要なものとは少し異なる場合があります。このような状況に対して、Juliaは非標準の文字列リテラルを提供しています。非標準の文字列リテラルは、通常の二重引用符で囲まれた文字列リテラルのように見えますが、識別子によってすぐに接頭辞が付けられ、通常の文字列リテラルとは異なる動作をする場合があります。

[Regular expressions](@ref man-regex-literals)、[byte array literals](@ref man-byte-array-literals)、および[version number literals](@ref man-version-number-literals)は、非標準の文字列リテラルのいくつかの例です。ユーザーやパッケージも新しい非標準の文字列リテラルを定義することがあります。さらなるドキュメントは、[Metaprogramming](@ref meta-non-standard-string-literals)セクションに記載されています。

## [Regular Expressions](@id man-regex-literals)

時には、正確な文字列を探しているのではなく、特定の*パターン*を探していることがあります。たとえば、大きなテキストファイルから単一の日付を抽出しようとしているとします。その日付が何であるかはわかりません（だからこそ探しているのですが）、ただそれが`YYYY-MM-DD`のように見えることは知っています。正規表現を使用すると、これらのパターンを指定して検索することができます。

Juliaは、[PCRE](https://www.pcre.org/)ライブラリによって提供されるPerl互換の正規表現（regex）のバージョン2を使用します（詳細については[PCRE2 syntax description](https://www.pcre.org/current/doc/html/pcre2syntax.html)を参照してください）。正規表現は文字列に2つの方法で関連しています。明らかな関連は、正規表現が文字列内の正規パターンを見つけるために使用されることです。もう一つの関連は、正規表現自体が文字列として入力され、文字列内のパターンを効率的に検索するために使用される状態遷移機械に解析されることです。Juliaでは、正規表現は`r`で始まるさまざまな識別子で接頭辞が付けられた非標準の文字列リテラルを使用して入力されます。オプションがオンになっていない最も基本的な正規表現リテラルは、単に`r"..."`を使用します：

```jldoctest
julia> re = r"^\s*(?:#|$)"
r"^\s*(?:#|$)"

julia> typeof(re)
Regex
```

文字列が正規表現に一致するかどうかを確認するには、[`occursin`](@ref)を使用します：

```jldoctest
julia> occursin(r"^\s*(?:#|$)", "not a comment")
false

julia> occursin(r"^\s*(?:#|$)", "# a comment")
true
```

ここで見ることができるように、[`occursin`](@ref)は、与えられた正規表現が文字列に一致するかどうかを示す真または偽を返します。しかし、一般的には、文字列が一致したかどうかだけでなく、*どのように*一致したかも知りたいものです。この一致に関する情報を取得するには、代わりに[`match`](@ref)関数を使用します。

```jldoctest
julia> match(r"^\s*(?:#|$)", "not a comment")

julia> match(r"^\s*(?:#|$)", "# a comment")
RegexMatch("#")
```

正規表現が指定された文字列に一致しない場合、[`match`](@ref) は [`nothing`](@ref) を返します - インタラクティブプロンプトでは何も表示されない特別な値です。表示されない以外は、完全に通常の値であり、プログラム的にテストすることができます：

```julia
m = match(r"^\s*(?:#|$)", line)
if m === nothing
    println("not a comment")
else
    println("blank or comment")
end
```

正規表現が一致する場合、[`match`](@ref) によって返される値は [`RegexMatch`](@ref) オブジェクトです。これらのオブジェクトは、式がどのように一致するかを記録し、パターンが一致する部分文字列や、キャプチャされた部分文字列（ある場合）を含みます。この例では、一致する部分の文字列のみをキャプチャしますが、コメント文字の後にある空白以外のテキストをキャプチャしたいかもしれません。次のようにすることができます：

```jldoctest
julia> m = match(r"^\s*(?:#\s*(.*?)\s*$)", "# a comment ")
RegexMatch("# a comment ", 1="a comment")
```

[`match`](@ref)を呼び出すとき、検索を開始するインデックスを指定するオプションがあります。例えば:

```jldoctest
julia> m = match(r"[0-9]","aaaa1aaaa2aaaa3",1)
RegexMatch("1")

julia> m = match(r"[0-9]","aaaa1aaaa2aaaa3",6)
RegexMatch("2")

julia> m = match(r"[0-9]","aaaa1aaaa2aaaa3",11)
RegexMatch("3")
```

`RegexMatch`オブジェクトから以下の情報を抽出できます:

  * 一致した全体の部分文字列: `m.match`
  * キャプチャされた部分文字列を文字列の配列として: `m.captures`
  * 全体のマッチが始まるオフセット: `m.offset`
  * キャプチャされたサブストリングのオフセットをベクトルとして: `m.offsets`

キャプチャが一致しない場合、部分文字列の代わりに、`m.captures` にはその位置に `nothing` が含まれ、`m.offsets` にはゼロオフセットがあります（Juliaのインデックスは1ベースであるため、文字列へのゼロオフセットは無効です）。以下は、やや作り込まれた例のペアです：

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

キャプチャが配列として返されるのは便利で、これにより分割代入構文を使用してローカル変数にバインドできます。便利なことに、`RegexMatch`オブジェクトは`captures`フィールドに渡すイテレーターメソッドを実装しているため、マッチオブジェクトを直接分割代入できます。

```jldoctest acdmatch
julia> first, second, third = m; first
"a"
```

キャプチャは、キャプチャグループの番号または名前を使って `RegexMatch` オブジェクトをインデックス指定することでもアクセスできます:

```jldoctest
julia> m=match(r"(?<hour>\d+):(?<minute>\d+)","12:45")
RegexMatch("12:45", hour="12", minute="45")

julia> m[:minute]
"45"

julia> m[2]
"45"
```

キャプチャは、[`replace`](@ref)を使用する際に置換文字列で参照できます。`\n`を使用してn番目のキャプチャグループを参照し、置換文字列の先頭に`s`を付けます。キャプチャグループ0は、全体のマッチオブジェクトを参照します。名前付きキャプチャグループは、置換で`\g<groupname>`を使用して参照できます。例えば：

```jldoctest
julia> replace("first second", r"(\w+) (?<agroup>\w+)" => s"\g<agroup> \1")
"second first"
```

番号付きキャプチャグループは、曖昧さを避けるために `\g<n>` としても参照できます。例えば:

```jldoctest
julia> replace("a", r"." => s"\g<0>1")
"a1"
```

正規表現の動作は、閉じた二重引用符の後にフラグ `i`、`m`、`s`、および `x` の組み合わせを使用することで変更できます。これらのフラグは、Perlと同じ意味を持ちます。これは、[perlre manpage](https://perldoc.perl.org/perlre#Modifiers) の抜粋で説明されています。

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

例えば、次の正規表現はすべてのフラグがオンになっています：

```jldoctest
julia> r"a+.*b+.*d$"ism
r"a+.*b+.*d$"ims

julia> match(r"a+.*b+.*d$"ism, "Goodbye,\nOh, angry,\nBad world\n")
RegexMatch("angry,\nBad world")
```

`r"..."` リテラルは、補間やエスケープなしで構築されます（引用符 `"` はエスケープする必要がありますが）。以下は、標準の文字列リテラルとの違いを示す例です：

```julia-repl
julia> x = 10
10

julia> r"$x"
r"$x"

julia> "$x"
"10"

julia> r"\x"
r"\x"

julia> "\x"
ERROR: syntax: invalid escape sequence
```

三重引用の正規表現文字列、形式 `r"""..."""` もサポートされており（引用符や改行を含む正規表現に便利な場合があります）、使用できます。

`Regex()` コンストラクタは、プログラム的に有効な正規表現文字列を作成するために使用できます。これにより、正規表現文字列を構築する際に文字列変数の内容や他の文字列操作を使用することができます。上記の正規表現コードのいずれかを `Regex()` の単一文字列引数内で使用できます。以下はいくつかの例です：

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

`\Q...\E` エスケープシーケンスの使用に注意してください。 `\Q` と `\E` の間のすべての文字はリテラル文字として解釈されます。これは、そうでなければ正規表現のメタキャラクターとなる文字を一致させるのに便利です。ただし、この機能を文字列補間と一緒に使用する際には注意が必要です。なぜなら、補間された文字列自体が `\E` シーケンスを含む可能性があり、リテラル一致が予期せず終了してしまうからです。ユーザー入力は、正規表現に含める前にサニタイズする必要があります。

## [Byte Array Literals](@id man-byte-array-literals)

もう一つの便利な非標準文字列リテラルは、バイト配列文字列リテラルです：`b"..."`。この形式を使用すると、文字列表記を使って読み取り専用のリテラルバイト配列を表現できます。つまり、[`UInt8`](@ref) 値の配列です。これらのオブジェクトの型は `CodeUnits{UInt8, String}` です。バイト配列リテラルのルールは以下の通りです：

  * ASCII文字とASCIIエスケープは1バイトを生成します。
  * `\x` および八進数エスケープシーケンスは、エスケープ値に対応する *バイト* を生成します。
  * Unicodeエスケープシーケンスは、そのコードポイントをUTF-8でエンコードするバイトのシーケンスを生成します。

これらのルールにはいくつかの重複があります。なぜなら、`\x` の動作と0x80（128）未満の8進数エスケープは最初の2つのルールの両方でカバーされているからですが、ここではこれらのルールは一致しています。これらのルールを組み合わせることで、ASCII文字、任意のバイト値、およびUTF-8シーケンスを簡単に使用してバイトの配列を生成できます。以下は、3つすべてを使用した例です：

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

ASCII文字列「DATA」は、バイト68、65、84、65に対応します。 `\xff`は単一バイト255を生成します。 Unicodeエスケープ`\u2200`は、UTF-8で3バイト226、136、128としてエンコードされます。 結果として得られるバイト配列は、有効なUTF-8文字列には対応しないことに注意してください：

```jldoctest
julia> isvalid("DATA\xff\u2200")
false
```

`CodeUnits{UInt8, String}` 型は `UInt8` の読み取り専用配列のように振る舞い、標準のベクターが必要な場合は `Vector{UInt8}` を使用して変換できます:

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

また、`\xff`と`\uff`の間には重要な違いがあることに注意してください。前者のエスケープシーケンスは*バイト255*をエンコードしますが、後者のエスケープシーケンスは*コードポイント255*を表し、これはUTF-8では2バイトでエンコードされます。

```jldoctest
julia> b"\xff"
1-element Base.CodeUnits{UInt8, String}:
 0xff

julia> b"\uff"
2-element Base.CodeUnits{UInt8, String}:
 0xc3
 0xbf
```

文字リテラルは同じ動作を使用します。

コードポイントが `\u80` 未満の場合、各コードポイントのUTF-8エンコーディングは、対応する `\x` エスケープによって生成される単一バイトと一致するため、その区別は安全に無視できます。しかし、`\x80` から `\xff` と `\u80` から `\uff` のエスケープには大きな違いがあります。前者のエスケープはすべて単一バイトをエンコードしており、非常に特定の継続バイトが続かない限り、有効なUTF-8データを形成しません。一方、後者のエスケープはすべて2バイトエンコーディングでUnicodeコードポイントを表します。

もしこれが非常に混乱している場合は、["The Absolute Minimum Every Software Developer Absolutely, Positively Must Know About Unicode and Character Sets"](https://www.joelonsoftware.com/2003/10/08/the-absolute-minimum-every-software-developer-absolutely-positively-must-know-about-unicode-and-character-sets-no-excuses/)を読んでみてください。これはUnicodeとUTF-8の優れた入門書であり、この問題に関する混乱を軽減するのに役立つかもしれません。

## [Version Number Literals](@id man-version-number-literals)

バージョン番号は、[`v"..."`](@ref @v_str) の形式の非標準文字列リテラルで簡単に表現できます。バージョン番号リテラルは、[semantic versioning 2.0.0-rc2](https://semver.org/spec/v2.0.0-rc.2.html) の仕様に従う [`VersionNumber`](@ref) オブジェクトを作成します。したがって、これらはメジャー、マイナー、パッチの数値値で構成され、その後にプレリリースおよびビルドの英数字注釈が続きます。例えば、`v"0.2.1-rc1+win64"` はメジャーバージョン `0`、マイナーバージョン `2`、パッチバージョン `1`、プレリリース `rc1`、ビルド `win64` に分解されます。バージョンリテラルを入力する際、メジャーバージョン番号以外はすべてオプションであるため、例えば `v"0.2"` は `v"0.2.0"`（空のプレリリース/ビルド注釈付き）と同等であり、`v"2"` は `v"2.0.0"` と同等です。

`VersionNumber` オブジェクトは、2つ以上のバージョンを簡単かつ正確に比較するために主に便利です。例えば、定数 [`VERSION`](@ref) は、`VersionNumber` オブジェクトとしてのJuliaバージョン番号を保持しており、したがって、次のような簡単なステートメントを使用してバージョン固有の動作を定義することができます:

```julia
if v"0.2" <= VERSION < v"0.3-"
    # do something specific to 0.2 release series
end
```

上記の例では、非標準のバージョン番号 `v"0.3-"` が使用されており、末尾に `-` が付いています。この表記は、標準のJulia拡張であり、すべてのプレリリースを含む `0.3` リリースよりも低いバージョンを示すために使用されます。したがって、上記の例では、コードは安定した `0.2` バージョンでのみ実行され、`v"0.3.0-rc1"` のようなバージョンは除外されます。不安定（すなわちプレリリース）の `0.2` バージョンも許可するために、下限チェックは次のように修正する必要があります: `v"0.2-" <= VERSION`。

別の非標準のバージョン仕様拡張では、ビルドバージョンの上限を表現するために末尾に `+` を使用することができます。たとえば、 `VERSION > v"0.2-rc1+"` は `0.2-rc1` より上の任意のバージョンとそのビルドを意味します：バージョン `v"0.2-rc1+win64"` に対しては `false` を返し、 `v"0.2-rc2"` に対しては `true` を返します。

特別なバージョンを比較に使用することは良い習慣です（特に、上限には常に末尾の `-` を使用すべきですが、正当な理由がない限りは使用しないべきです）が、実際のバージョン番号として使用してはいけません。なぜなら、それらはセマンティックバージョニングスキームでは無効だからです。

[`VERSION`](@ref) 定数に使用されるだけでなく、`VersionNumber` オブジェクトは `Pkg` モジュールで広く使用されており、パッケージのバージョンとその依存関係を指定します。

## [Raw String Literals](@id man-raw-string-literals)

生の文字列は、`raw"..."`の形式の非標準文字列リテラルで表現できます。生の文字列リテラルは、埋め込みやエスケープなしで入力された内容をそのまま含む通常の`String`オブジェクトを作成します。これは、`$`や`\`を特殊文字として使用する他の言語のコードやマークアップを含む文字列に便利です。

例外として、引用符は依然としてエスケープする必要があります。たとえば、`raw"\""`は`"\""`と同等です。すべての文字列を表現できるようにするために、バックスラッシュもエスケープする必要がありますが、これは引用文字の直前に現れる場合のみです。

```jldoctest
julia> println(raw"\\ \\\"")
\\ \"
```

最初の2つのバックスラッシュは出力にそのまま表示されます。なぜなら、それらは引用文字の前にないからです。しかし、次のバックスラッシュ文字はその後に続くバックスラッシュをエスケープし、最後のバックスラッシュは引用をエスケープします。なぜなら、これらのバックスラッシュは引用の前にあるからです。

## [Annotated Strings](@id man-annotated-strings)

!!! note
    AnnotatedStringsのAPIは実験的と見なされており、Juliaのバージョン間で変更される可能性があります。


文字列の領域に関連するメタデータを保持できることは、時には便利です。[`AnnotatedString`](@ref Base.AnnotatedString)は別の文字列をラップし、その一部にラベル付きの値（`:label => value`）で注釈を付けることを可能にします。すべての一般的な文字列操作は、基になる文字列に適用されます。ただし、可能な場合はスタイリング情報が保持されます。これは、`4d61726b646f776e2e436f64652822222c2022416e6e6f7461746564537472696e672229_4072656620426173652e416e6e6f7461746564537472696e67`を操作することができることを意味します—部分文字列を取り出したり、パディングを施したり、他の文字列と連結したりしても、メタデータの注釈は「一緒に付いてくる」のです。

この文字列タイプは、スタイリング情報を保持するために `:face` ラベル付きの注釈を使用する [StyledStrings stdlib](@ref stdlib-styledstrings) にとって基本的です。

When concatenating a [`AnnotatedString`](@ref Base.AnnotatedString), take care to use [`annotatedstring`](@ref Base.annotatedstring) instead of [`string`](@ref) if you want to keep the string annotations.

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

[`AnnotatedString`](@ref Base.AnnotatedString) の注釈は、[`annotations`](@ref Base.annotations) および [`annotate!`](@ref Base.annotate!) 関数を介してアクセスおよび変更できます。
