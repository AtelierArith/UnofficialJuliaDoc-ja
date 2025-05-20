# [Variables](@id man-variables)

変数は、Juliaにおいて値に関連付けられた（または束縛された）名前です。これは、後で使用するために値（例えば、いくつかの数学の後に得られた値）を保存したいときに便利です。例えば：

```julia-repl
# Assign the value 10 to the variable x
julia> x = 10
10

# Doing math with x's value
julia> x + 1
11

# Reassign x's value
julia> x = 1 + 1
2

# You can assign values of other types, like strings of text
julia> x = "Hello World!"
"Hello World!"
```

Juliaは、変数名を付けるための非常に柔軟なシステムを提供します。変数名は大文字と小文字を区別し、意味を持ちません（つまり、言語は変数の名前に基づいて変数を異なるものとして扱うことはありません）。

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

Unicode名（UTF-8エンコーディングで）は許可されています：

```jldoctest
julia> δ = 0.00001
1.0e-5

julia> 안녕하세요 = "Hello"
"Hello"
```

JuliaのREPLや他のいくつかのJulia編集環境では、バックスラッシュ付きのLaTeXシンボル名を入力し、次にタブを押すことで多くのUnicode数学記号を入力できます。たとえば、変数名`δ`は`\delta`-タブ、または`α̂⁽²⁾`は`\alpha`-タブ-`\hat`-タブ-`\^(2)`-タブで入力できます。（誰かのコードなどでシンボルを見つけて、それを入力する方法がわからない場合、REPLのヘルプが教えてくれます。`?`を入力してからシンボルを貼り付けてください。）

Juliaは、既存のエクスポートされた定数や関数をローカルのもので影にすることを許可します（ただし、混乱を避けるために推奨されません）：

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

ただし、すでに使用中の組み込み定数や関数を再定義しようとすると、Juliaはエラーを返します：

```jldoctest
julia> pi
π = 3.1415926535897...

julia> pi = 3
ERROR: cannot assign a value to imported variable Base.pi from module Main

julia> sqrt(100)
10.0

julia> sqrt = 4
ERROR: cannot assign a value to imported variable Base.sqrt from module Main
```

## [Allowed Variable Names](@id man-allowed-variable-names)

変数名は、文字（A-Zまたはa-z）、アンダースコア、またはUnicodeコードポイントのサブセット（00A0より大きい）で始める必要があります。特に、[Unicode character categories](https://www.fileformat.info/info/unicode/category/index.htm) Lu/Ll/Lt/Lm/Lo/Nl（文字）、Sc/So（通貨およびその他の記号）、およびいくつかの他の文字のような文字（例：Sm数学記号のサブセット）が許可されています。続く文字には、!や数字（0-9およびNd/Noカテゴリの他の文字）も含めることができ、他のUnicodeコードポイント：ダイアクリティックやその他の修飾マーク（Mn/Mc/Me/Skカテゴリ）、いくつかの句読点コネクタ（Pcカテゴリ）、プライム、およびいくつかの他の文字も含まれます。

演算子 `+` のようなものも有効な識別子ですが、特別に解析されます。いくつかの文脈では、演算子は変数のように使用できます。たとえば、`(+)` は加算関数を指し、`(+) = f` はそれを再割り当てします。Unicodeの中置演算子（Smカテゴリに属する）である `⊕` のようなものは、中置演算子として解析され、ユーザー定義のメソッドで使用可能です（たとえば、`const ⊗ = kron` を使用して `⊗` を中置のクロネッカー積として定義できます）。演算子は修飾マーク、プライム、下付き/上付き文字で修飾することもでき、たとえば `+̂ₐ″` は `+` と同じ優先順位の中置演算子として解析されます。下付き/上付き文字で終わる演算子とその後の変数名の間にはスペースが必要です。たとえば、`+ᵃ` が演算子である場合、`+ᵃx` は `+ᵃ x` と書かなければならず、`+ ᵃx` の場合は `ᵃx` が変数名であることを区別します。

特定の変数名のクラスは、アンダースコアのみを含むものです。これらの識別子は書き込み専用です。つまり、値を割り当てることはできますが、それはすぐに破棄され、その値は何の方法でも使用できません。

```julia-repl
julia> x, ___ = size([2 2; 1 1])
(2, 2)

julia> y = ___
ERROR: syntax: all-underscore identifiers are write-only and their values cannot be used in expressions

julia> println(___)
ERROR: syntax: all-underscore identifiers are write-only and their values cannot be used in expressions
```

The only explicitly disallowed names for variables are the names of the built-in [Keywords](@ref Keywords):

```julia-repl
julia> else = false
ERROR: syntax: unexpected "else"

julia> try = "No"
ERROR: syntax: unexpected "="
```

一部のUnicode文字は、識別子において同等と見なされます。Unicode結合文字（例：アクセント）の異なる入力方法は同等と見なされます（具体的には、Juliaの識別子は [NFC](https://en.wikipedia.org/wiki/Unicode_equivalence) です）。Juliaは、視覚的に似ていて、いくつかの入力方法で簡単に入力できる文字に対して、いくつかの非標準の同等性も含んでいます。Unicode文字 `ɛ` (U+025B: ラテン小文字オープンe) と `µ` (U+00B5: マイクロサイン) は、対応するギリシャ文字と同等と見なされます。中点 `·` (U+00B7) とギリシャの [interpunct](https://en.wikipedia.org/wiki/Interpunct) `·` (U+0387) は、数学的な点演算子 `⋅` (U+22C5) として同等と見なされます。マイナス記号 `−` (U+2212) は、ハイフンマイナス記号 `-` (U+002D) と同等と見なされます。

## [Assignment expressions and assignment versus mutation](@id man-assignment-expressions)

`variable = value` という代入は、名前 `variable` を右辺で計算された `value` に「バインド」し、全体の代入はJuliaによって右辺の `value` と等しい式として扱われます。これは、代入が *チェーン* できる（同じ `value` を複数の変数に `variable1 = variable2 = value` として代入できる）ことや、他の式で使用できる理由でもあり、その結果がREPLで右辺の値として表示される理由でもあります。（一般的に、REPLは評価した式の値を表示します。）例えば、ここでは `b = 2+2` の値 `4` が別の算術演算と代入に使用されています：

```jldoctest
julia> a = (b = 2+2) + 3
7

julia> a
7

julia> b
4
```

一般的な混乱は、*代入*（値に新しい「名前」を付けること）と*変異*（値を変更すること）の区別です。 `a = 2` の後に `a = 3` を実行すると、名前 `a` が新しい値 `3` を指すように変更されます… 数字 `2` は変更されていないので、`2+2` は依然として `4` を返し、`6` にはなりません！ この区別は、内容が*変更可能*な型（例えば [arrays](@ref lib-arrays)）を扱うときにより明確になります。

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

ここで、行 `b = a` は配列 `a` のコピーを作成するのではなく、単に名前 `b` を同じ配列 `a` にバインドします：`b` と `a` は両方ともメモリ内の同じ配列 `[1,2,3]` を「指しています」。対照的に、代入 `a[i] = value` は配列の*内容*を*変更*し、変更された配列は名前 `a` と `b` の両方を通じて見ることができます：

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

つまり、`a[i] = value`（[`setindex!`](@ref)のエイリアス）は、`a`または`b`を介してアクセス可能なメモリ内の既存の配列オブジェクトを*変更*します。その後、`a = 3.14159`を設定しても、この配列は変更されず、単に`a`が別のオブジェクトにバインドされるだけです。配列は依然として`b`を介してアクセス可能です。既存のオブジェクトを変更するためのもう一つの一般的な構文は、`a.field = value`（[`setproperty!`](@ref)のエイリアス）であり、これを使用して[`mutable struct`](@ref)を変更することができます。また、ドット代入による変更もあり、例えば`b .= 5:7`（これは配列`b`をその場で変更して`[5,6,7]`を含むようにします）などがあります。これはJuliaの[vectorized "dot" syntax](@ref man-dot-operators)の一部です。

[function](@ref man-functions)をJuliaで呼び出すと、引数の値が関数の引数に対応する新しい変数名に*割り当てられた*かのように振る舞います。これは、[Argument-Passing Behavior](@ref man-argument-passing)で説明されています。 ([convention](@ref man-punctuation)によって、引数の1つ以上を変更する関数は`!`で終わる名前を持っています。)

## Stylistic Conventions

Juliaは有効な名前に対してほとんど制限を課しませんが、以下の慣習を採用することが有用になっています：

  * 変数の名前は小文字です。
  * 単語の区切りはアンダースコア（`'_'`）で示すことができますが、名前が読みづらくない限り、アンダースコアの使用は推奨されません。
  * `Type`や`Module`の名前は大文字で始まり、単語の区切りはアンダースコアの代わりに大文字のキャメルケースで示されます。
  * 関数とマクロの名前は小文字で、アンダースコアなしです。
  * 引数に書き込む関数は、名前が `!` で終わります。これらは「ミューテーション」または「インプレース」関数と呼ばれることもあり、関数が呼び出された後に引数に変更を加えることを意図しているため、単に値を返すだけではありません。

スタイリスティックな慣習に関する詳細は、[Style Guide](@ref)を参照してください。
