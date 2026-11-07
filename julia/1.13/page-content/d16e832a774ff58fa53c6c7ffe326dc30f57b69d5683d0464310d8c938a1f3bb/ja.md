# [Variables](@id man-variables)

Juliaにおける変数とは、値に関連付けられた（または値に束縛された）名前です。たとえば、計算して得た値を後で使うために保存しておきたい場合に便利です。例を示します。

```jldoctest
julia> x = 10   # Assign the value 10 to the variable x
10

julia> x + 1    # Doing math with x's value
11

julia> x = 1 + 1   # Reassign x's value
2

julia> x = "Hello World!"   # You can assign values of other types, like strings of text
"Hello World!"
```

Juliaでは、変数名を非常に柔軟に付けられます。変数名は大文字と小文字が区別されますが、意味上の違いはありません（つまり、名前によって変数の扱いが変わることはありません）。

```jldoctest
julia> x = 1.0
1.0

julia> y = -3
-3

julia> Z = "My string"
"My string"

julia> customary_phrase = "Hello world!"
"Hello world!"

julia> UniversalDeclarationOfHumanRightsStart = "人人生而自由，在尊严和权利上一律平等。"
"人人生而自由，在尊严和权利上一律平等。"
```

Unicode名（UTF-8エンコーディング）も使用できます。

```jldoctest
julia> δ = 0.00001
1.0e-5

julia> 안녕하세요 = "Hello"
"Hello"
```

Julia REPLや、その他いくつかのJulia編集環境では、バックスラッシュに続けてLaTeXの記号名を入力し、Tabキーを押すと、多くのUnicode数学記号を入力できます。たとえば、変数名 `δ` は、`\delta`-*tab* と入力すれば入力できます。また、`α̂⁽²⁾` は、`\alpha`-*tab*-`\hat`- *tab*-`\^(2)`-*tab* と入力できます。（たとえば他の人のコードなどで、入力方法がわからない記号を見つけた場合は、REPLのヘルプで調べられます。`?` と入力してから、その記号を貼り付けてください。）

Juliaでは、既存のエクスポート済み定数や関数をローカルな名前でシャドーイングすることもできます（混乱を招く可能性があるため、推奨はされません）。

```jldoctest; filter = r"with \d+ methods"
julia> pi = 3
3

julia> pi
3

julia> sqrt = 4
4

julia> length() = 5
length (generic function with 1 method)

julia> Base.length
length (generic function with 79 methods)
```

ただし、明示的にインポートした組み込み定数や関数を再定義しようとすると、Juliaはエラーを出します。

```jldoctest
julia> using Base: pi, sqrt

julia> pi
π = 3.1415926535897...

julia> pi = 3
ERROR: cannot assign a value to imported variable Base.pi from module Main

julia> sqrt(100)
10.0

julia> sqrt = 4
ERROR: cannot assign a value to imported variable Base.sqrt from module Main
```

!!! compat "Julia 1.12"



Julia 1.12より前のバージョンでは、これらのエラーは、競合する束縛の定義時ではなく、使用時に発生していたことに注意してください。

## [Allowed Variable Names](@id man-allowed-variable-names)

変数名の先頭には、英字（A-Zまたはa-z）、アンダースコア、またはU+00A0より大きいUnicodeコードポイントの一部を使用できます。具体的には、[Unicode character categories](https://www.fileformat.info/info/unicode/category/index.htm) Lu/Ll/Lt/Lm/Lo/Nl（文字）、Sc/So（通貨記号など）、および文字に似たその他いくつかの文字（Sm数学記号の一部など）が使用できます。2文字目以降には、!や数字（0-9およびNd/Noカテゴリのその他の文字）に加え、ダイアクリティカルマークなどの修飾記号（Mn/Mc/Me/Skカテゴリ）、一部の句読点接続記号（Pcカテゴリ）、プライム記号、その他いくつかのUnicodeコードポイントも使用できます。

`+` のような演算子も有効な識別子ですが、特別な方法で解析されます。文脈によっては、演算子を変数と同じように使えます。たとえば、`(+)` は加算関数を指し、`(+) = f` はその関数を再代入します。`⊕` など、Unicodeの中置演算子の多く（Smカテゴリ）は中置演算子として解析され、ユーザー定義メソッドに使用できます（たとえば、`const ⊗ = kron` を使って、`⊗` を中置のクロネッカー積として定義できます）。演算子の末尾には、修飾記号、プライム記号、下付き文字や上付き文字を付けることもできます。たとえば、`+̂ₐ″` は、`+` と同じ優先順位を持つ中置演算子として解析されます。下付き文字または上付き文字の英字で終わる演算子の後に変数名を続ける場合は、間に空白が必要です。たとえば、`+ᵃ` が演算子なら、`+ᵃx` は、変数名が `ᵃx` である `+ ᵃx` と区別するため、`+ᵃ x` と書く必要があります。

アンダースコアだけで構成される変数名もあります。このような識別子は書き込み専用です。つまり、値を代入することしかできず、代入された値は直ちに破棄されるため、どのような方法でもその値を使うことはできません。

```jldoctest
julia> x, ___ = size([2 2; 1 1])
(2, 2)

julia> y = ___
ERROR: syntax: all-underscore identifiers are write-only and their values cannot be used in expressions

julia> println(___)
ERROR: syntax: all-underscore identifiers are write-only and their values cannot be used in expressions
```

変数名として明示的に使用が禁止されているのは、組み込みの[Keywords](@ref Keywords)の名前だけです。

```jldoctest
julia> else = false
ERROR: ParseError:
# Error @ none:1:1
else = false
└──┘ ── invalid identifier

julia> try = "No"
ERROR: ParseError:
# Error @ none:1:1
try = "No"
└────────┘ ── try without catch or finally
```

識別子では、一部のUnicode文字が同等のものとして扱われます。Unicode結合文字（アクセント記号など）は、入力方法が異なっていても同等に扱われます（具体的には、Juliaの識別子は[NFC](https://en.wikipedia.org/wiki/Unicode_equivalence)です）。またJuliaでは、見た目が似ていて一部の入力方法で簡単に入力できる文字について、標準外の同等性もいくつか定めています。Unicode文字`ɛ`（U+025B: ラテン小文字オープンe）と`µ`（U+00B5: マイクロ記号）は、それぞれ対応するギリシャ文字と同等に扱われます。中点`·`（U+00B7）とギリシャ文字の[interpunct](https://en.wikipedia.org/wiki/Interpunct) `·`（U+0387）は、どちらも数学のドット演算子`⋅`（U+22C5）と同等に扱われます。マイナス記号`−`（U+2212）は、ハイフンマイナス記号`-`（U+002D）と同等に扱われます。

## [Assignment expressions and assignment versus mutation](@id man-assignment-expressions)

代入`variable = value`は、右辺で計算された`value`に名前`variable`を「束縛」します。また、代入全体は、右辺の`value`と等しい式としてJuliaに扱われます。そのため、代入を連鎖させて（同じ`value`を`variable1 = variable2 = value`で複数の変数に代入して）使ったり、ほかの式の中で使ったりできます。また、REPLで右辺の値が結果として表示されるのもこのためです。（一般に、REPLは評価した式の値を表示します。）たとえば、ここでは`b = 2+2`の値`4`を、別の算術演算と代入で使っています。

```jldoctest
julia> a = (b = 2+2) + 3
7

julia> a
7

julia> b
4
```

よく混同されるのが、*代入*（値に新しい「名前」を付けること）と*変更*（値を変えること）の違いです。`a = 2` の後に `a = 3` を実行すると、名前`a`が新しい値`3`を指すようになります。数値`2`自体を変えたわけではないため、`2+2`の結果は`6`ではなく、引き続き`4`です。この違いは、内容を*変更できる*[arrays](@ref lib-arrays)のような*可変*型を扱うと、より明確になります。

```jldoctest mutation_vs_rebind
julia> a = [1,2,3] # an array of 3 integers
3-element Vector{Int64}:
 1
 2
 3

julia> b = a   # both b and a are names for the same array!
3-element Vector{Int64}:
 1
 2
 3
```

ここで、行`b = a`は配列`a`のコピーを作るのではなく、名前`b`を同じ配列`a`に束縛します。つまり、`b`と`a`は、メモリ上の1つの配列`[1,2,3]`を「指しています」。一方、代入`a[i] = value`は配列の*内容*を*変更*するため、変更後の配列は名前`a`と`b`のどちらからも参照できます。

```jldoctest mutation_vs_rebind
julia> a[1] = 42     # change the first element
42

julia> a = 3.14159   # a is now the name of a different object
3.14159

julia> b   # b refers to the original array object, which has been mutated
3-element Vector{Int64}:
 42
  2
  3
```

つまり、`a[i] = value`（[`setindex!`](@ref)の別名）は、メモリ上にある既存の配列オブジェクトを*変更*します。このオブジェクトには、`a`または`b`のどちらからでもアクセスできます。その後`a = 3.14159`を設定しても、この配列は変わりません。`a`が別のオブジェクトに束縛されるだけで、配列には引き続き`b`からアクセスできます。既存のオブジェクトを変更するもう1つの一般的な構文は`a.field = value`（[`setproperty!`](@ref)の別名）で、[`mutable struct`](@ref)を変更するために使えます。また、ドット代入による変更もあります。たとえば、`b .= 5:7`は、Juliaの[vectorized "dot" syntax](@ref man-dot-operators)の一部として、配列`b`の内容をその場で`[5,6,7]`に変更します。

Juliaで[function](@ref man-functions)を呼び出すと、[Argument-Passing Behavior](@ref man-argument-passing)で説明したように、引数の値を関数引数に対応する新しい変数名に*代入*したかのように動作します。（[convention](@ref man-punctuation)に従い、1つ以上の引数を変更する関数の名前は`!`で終わります。）

## Stylistic Conventions

Juliaでは有効な名前に対する制約はほとんどありませんが、次のような慣習が広く使われています。

  * 変数名は小文字で始めます。
  * 単語の区切りにはアンダースコア（`'_'`）を使えますが、ほかの方法では読みにくくなる場合を除き、アンダースコアの使用は推奨されません。
  * `Type`や`Module`の名前は大文字で始め、単語の区切りにはアンダースコアではなくアッパーキャメルケースを使います。
  * `function`や`macro`の名前は、小文字で書き、アンダースコアは使いません。
  * 引数を書き換える関数の名前は`!`で終わります。これらは「変更関数」または「インプレース関数」と呼ばれることもあります。関数の呼び出し後に値を返すだけでなく、引数に変更を加えることを意図した関数です。

スタイル上の慣習について詳しくは、[Style Guide](@ref)を参照してください。
