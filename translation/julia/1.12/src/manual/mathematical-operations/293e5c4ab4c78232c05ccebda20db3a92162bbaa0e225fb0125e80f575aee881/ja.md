# Mathematical Operations and Elementary Functions

Juliaは、すべての数値プリミティブ型にわたる基本的な算術演算子とビット演算子の完全なコレクションを提供し、包括的な標準数学関数のポータブルで効率的な実装も提供します。

## Arithmetic Operators

次の [arithmetic operators](https://en.wikipedia.org/wiki/Arithmetic#Arithmetic_operations) はすべての原始的な数値型でサポートされています：

| Expression | Name           | Description                            |
|:---------- |:-------------- |:-------------------------------------- |
| `+x`       | unary plus     | the identity operation                 |
| `-x`       | unary minus    | maps values to their additive inverses |
| `x + y`    | binary plus    | performs addition                      |
| `x - y`    | binary minus   | performs subtraction                   |
| `x * y`    | times          | performs multiplication                |
| `x / y`    | divide         | performs division                      |
| `x ÷ y`    | integer divide | x / y, truncated to an integer         |
| `x \ y`    | inverse divide | equivalent to `y / x`                  |
| `x ^ y`    | power          | raises `x` to the `y`th power          |
| `x % y`    | remainder      | equivalent to `rem(x, y)`              |

数値リテラルが識別子や括弧の直前に置かれると、例えば `2x` や `2(x + y)` のように、他の二項演算よりも優先度が高い乗算として扱われます。詳細については [Numeric Literal Coefficients](@ref man-numeric-literal-coefficients) を参照してください。

Julia's promotion system makes arithmetic operations on mixtures of argument types "just work" naturally and automatically. See [Conversion and Promotion](@ref conversion-and-promotion) for details of the promotion system.

÷ 記号は、REPL または Julia IDE で `\div<tab>` と入力することで便利に入力できます。詳細については [manual section on Unicode input](@ref Unicode-Input) を参照してください。

ここに算術演算子を使用したいくつかの簡単な例があります：

```jldoctest
julia> 1 + 2 + 3
6

julia> 1 - 2
-1

julia> 3*2/12
0.5
```

（慣例として、近くの他の演算子の前に適用される場合、演算子の間隔を狭くする傾向があります。たとえば、最初に `x` が否定され、その結果に `2` が加えられることを反映するために、一般的に `-x + 2` と書きます。）

乗算で使用されると、`false`は*強いゼロ*として機能します：

```jldoctest
julia> NaN * false
0.0

julia> false * Inf
0.0
```

これは、ゼロであることが知られている量における`NaN`値の伝播を防ぐのに役立ちます。動機については[Knuth (1992)](https://arxiv.org/abs/math/9205211)を参照してください。

## Boolean Operators

以下の [Boolean operators](https://en.wikipedia.org/wiki/Boolean_algebra#Operations) は [`Bool`](@ref) タイプでサポートされています：

| Expression | Name                                                    |
|:---------- |:------------------------------------------------------- |
| `!x`       | negation                                                |
| `x && y`   | [short-circuiting and](@ref man-conditional-evaluation) |
| `x \|\| y` | [short-circuiting or](@ref man-conditional-evaluation)  |

否定は `true` を `false` に、逆に `false` を `true` に変えます。ショートサーキット演算については、リンクされたページで説明されています。

`Bool`は整数型であり、通常の昇格ルールや数値演算子もそれに対して定義されています。

## Bitwise Operators

以下の [bitwise operators](https://en.wikipedia.org/wiki/Bitwise_operation#Bitwise_operators) はすべての基本整数型でサポートされています：

| Expression | Name                                                                     |
|:---------- |:------------------------------------------------------------------------ |
| `~x`       | bitwise not                                                              |
| `x & y`    | bitwise and                                                              |
| `x \| y`   | bitwise or                                                               |
| `x ⊻ y`    | bitwise xor (exclusive or)                                               |
| `x ⊼ y`    | bitwise nand (not and)                                                   |
| `x ⊽ y`    | bitwise nor (not or)                                                     |
| `x >>> y`  | [logical shift](https://en.wikipedia.org/wiki/Logical_shift) right       |
| `x >> y`   | [arithmetic shift](https://en.wikipedia.org/wiki/Arithmetic_shift) right |
| `x << y`   | logical/arithmetic shift left                                            |

ここにビット演算子のいくつかの例があります：

```jldoctest
julia> ~123
-124

julia> 123 & 234
106

julia> 123 | 234
251

julia> 123 ⊻ 234
145

julia> xor(123, 234)
145

julia> nand(123, 123)
-124

julia> 123 ⊼ 123
-124

julia> nor(123, 124)
-128

julia> 123 ⊽ 124
-128

julia> ~UInt32(123)
0xffffff84

julia> ~UInt8(123)
0x84
```

## Updating operators

すべての二項算術演算子およびビット単位演算子には、演算の結果を左オペランドに戻す更新バージョンがあります。二項演算子の更新バージョンは、演算子の直後に `=` を置くことによって形成されます。たとえば、`x += 3` と書くことは、`x = x + 3` と書くことと同じです：

```jldoctest
julia> x = 1
1

julia> x += 3
4

julia> x
4
```

すべての二進算術演算子およびビット演算子の更新バージョンは次のとおりです：

```
+=  -=  *=  /=  \=  ÷=  %=  ^=  &=  |=  ⊻=  >>>=  >>=  <<=
```

!!! note
    更新演算子は左辺の変数を再バインドします。その結果、変数の型が変わる可能性があります。

    ```jldoctest
    julia> x = 0x01; typeof(x)
    UInt8

    julia> x *= 2 # Same as x = x * 2
    2

    julia> typeof(x)
    Int64
    ```


## [Vectorized "dot" operators](@id man-dot-operators)

すべての二項演算子 `^` に対して、配列の要素ごとに `^` を実行するように自動的に定義された対応する "ドット" 演算子 `.^` があります。たとえば、`[1, 2, 3] ^ 3` は定義されていません。なぜなら、（非正方）配列を "三乗" するという標準的な数学的意味がないからです。しかし、`[1, 2, 3] .^ 3` は、要素ごとの（または "ベクトル化された"）結果 `[1^3, 2^3, 3^3]` を計算するように定義されています。同様に、`!` や `√` のような単項演算子に対しても、演算子を要素ごとに適用する `.√` が対応しています。

```jldoctest
julia> [1, 2, 3] .^ 3
3-element Vector{Int64}:
  1
  8
 27
```

より具体的には、`a .^ b` は ["dot" call](@ref man-vectorized) `(^).(a,b)` として解析され、[broadcast](@ref Broadcasting) 操作を実行します：これは配列とスカラー、同じサイズの配列（要素ごとに操作を実行）、さらには異なる形状の配列（例えば、行ベクトルと列ベクトルを組み合わせて行列を生成する）を組み合わせることができます。さらに、すべてのベクトル化された「ドット呼び出し」と同様に、これらの「ドット演算子」は*融合*しています。例えば、配列 `A` に対して `2 .* A.^2 .+ sin.(A)`（または同等の `@. 2A^2 + sin(A)`、[`@.`](@ref @__dot__) マクロを使用）を計算すると、`A` の各要素 `a` に対して `2a^2 + sin(a)` を計算する*単一*のループが実行されます。特に、`f.(g.(x))` のようなネストされたドット呼び出しは融合され、「隣接する」二項演算子 `x .+ 3 .* x.^2` はネストされたドット呼び出し `(+).(x, (*).(3, (^).(x, 2)))` と同等です。

さらに、`a .+= b`（または`@. a += b`）のような「ドット」更新演算子は、`a .= a .+ b`として解析されます。ここで、`.=`は融合された*インプレース*代入操作です（[dot syntax documentation](@ref man-vectorized)を参照してください）。

ドット構文はユーザー定義演算子にも適用可能です。たとえば、`⊗(A, B) = kron(A, B)`と定義すると、クロンカー積のための便利な中置構文`A ⊗ B`が得られます（[`kron`](@ref)）。この場合、`[A, B] .⊗ [C, D]`は追加のコーディングなしで`[A⊗C, B⊗D]`を計算します。

ドット演算子と数値リテラルを組み合わせることは曖昧になる可能性があります。たとえば、`1.+x` が `1. + x` を意味するのか `1 .+ x` を意味するのかは明確ではありません。したがって、この構文は許可されておらず、そのような場合には演算子の周りにスペースを使用する必要があります。

## Numeric Comparisons

すべてのプリミティブ数値型に対して標準の比較演算が定義されています：

| Operator                     | Name                     |
|:---------------------------- |:------------------------ |
| [`==`](@ref)                 | equality                 |
| [`!=`](@ref), [`≠`](@ref !=) | inequality               |
| [`<`](@ref)                  | less than                |
| [`<=`](@ref), [`≤`](@ref <=) | less than or equal to    |
| [`>`](@ref)                  | greater than             |
| [`>=`](@ref), [`≥`](@ref >=) | greater than or equal to |

ここにいくつかの簡単な例があります：

```jldoctest
julia> 1 == 1
true

julia> 1 == 2
false

julia> 1 != 2
true

julia> 1 == 1.0
true

julia> 1 < 2
true

julia> 1.0 > 3
false

julia> 1 >= 1.0
true

julia> -1 <= 1
true

julia> -1 <= -1
true

julia> -1 <= -2
false

julia> 3 < -0.5
false
```

整数は標準的な方法で比較されます – ビットの比較によって。浮動小数点数は [IEEE 754 standard](https://en.wikipedia.org/wiki/IEEE_754-2008) に従って比較されます:

  * 有限数は通常の方法で順序付けられています。
  * 正のゼロは負のゼロと等しいが、それより大きくはない。
  * `Inf` は自分自身と等しく、`NaN` を除くすべてのものよりも大きいです。
  * `-Inf`は自分自身と等しく、`NaN`を除くすべてのものよりも小さいです。
  * `NaN` は、自己を含む何にも等しくなく、何にも小さくなく、何にも大きくありません。

最後のポイントは潜在的に驚くべきものであり、注目に値します：

```jldoctest
julia> NaN == NaN
false

julia> NaN != NaN
true

julia> NaN < NaN
false

julia> NaN > NaN
false
```

および [arrays](@ref man-multi-dim-arrays) を使用しているときに頭痛を引き起こす可能性があります：

```jldoctest
julia> [1 NaN] == [1 NaN]
false
```

Juliaは、ハッシュキーの比較のような状況で役立つ特別な値をテストするための追加の関数を提供します。

| Function                | Tests if                  |
|:----------------------- |:------------------------- |
| [`isequal(x, y)`](@ref) | `x` and `y` are identical |
| [`isfinite(x)`](@ref)   | `x` is a finite number    |
| [`isinf(x)`](@ref)      | `x` is infinite           |
| [`isnan(x)`](@ref)      | `x` is not a number       |

[`isequal`](@ref) は `NaN` を互いに等しいと見なします：

```jldoctest
julia> isequal(NaN, NaN)
true

julia> isequal([1 NaN], [1 NaN])
true

julia> isequal(NaN, NaN32)
true
```

`isequal` は符号付きゼロを区別するためにも使用できます:

```jldoctest
julia> -0.0 == 0.0
true

julia> isequal(-0.0, 0.0)
false
```

符号付き整数、符号なし整数、および浮動小数点数の混合型比較は難しい場合があります。Juliaがそれらを正しく行うために多くの注意が払われています。

他のタイプの場合、`isequal`はデフォルトで[`==`](@ref)を呼び出します。したがって、自分のタイプの等価性を定義したい場合は、`4d61726b646f776e2e436f64652822222c20223d3d2229_40726566`メソッドを追加するだけで済みます。独自の等価性関数を定義する場合は、`isequal(x,y)`が`hash(x) == hash(y)`を意味することを保証するために、対応する[`hash`](@ref)メソッドを定義することをお勧めします。

### Chaining comparisons

他のほとんどの言語とは異なり、[notable exception of Python](https://en.wikipedia.org/wiki/Python_syntax_and_semantics#Comparison_operators)では、比較を任意に連鎖させることができます：

```jldoctest
julia> 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
true
```

数値コードでは、比較を連鎖させることが非常に便利です。連鎖比較はスカラー比較に `&&` 演算子を使用し、要素ごとの比較には [`&`](@ref) 演算子を使用します。これにより、配列に対しても機能します。例えば、`0 .< A .< 1` は、`A` の対応する要素が 0 と 1 の間にある場合に真となるブール配列を返します。

連鎖比較の評価動作に注意してください：

```jldoctest
julia> v(x) = (println(x); x)
v (generic function with 1 method)

julia> v(1) < v(2) <= v(3)
2
1
3
true

julia> v(1) > v(2) <= v(3)
2
1
false
```

中間の式は一度だけ評価され、式が `v(1) < v(2) && v(2) <= v(3)` のように書かれていた場合の二度評価されることはありません。ただし、連鎖比較における評価の順序は未定義です。副作用（例えば、印刷など）のある式を連鎖比較で使用しないことを強く推奨します。副作用が必要な場合は、短絡 `&&` 演算子を明示的に使用するべきです（参照: [Short-Circuit Evaluation](@ref)）。

### Elementary Functions

Juliaは、数学関数と演算子の包括的なコレクションを提供します。これらの数学的操作は、整数、浮動小数点数、有理数、複素数など、意味のある定義を許す限り広範な数値のクラスにわたって定義されています。

さらに、これらの関数（他のすべてのJulia関数と同様に）は、[dot syntax](@ref man-vectorized) `f.(A)`を使用して配列や他のコレクションに「ベクトル化」された方法で適用できます。たとえば、`sin.(A)`は配列`A`の各要素の正弦を計算します。

## Operator Precedence and Associativity

ジュリアは、演算の優先順位を以下のように適用します。最高の優先順位から最低の優先順位まで:

| Category       | Operators                                              | Associativity   |
|:-------------- |:------------------------------------------------------ |:--------------- |
| Syntax         | `.` followed by `::`                                   | Left            |
| Exponentiation | `^`                                                    | Right           |
| Unary          | `+ - ! ~ ¬ √ ∛ ∜ ⋆ ± ∓ <: >:`                          | Right[^1]       |
| Bitshifts      | `<< >> >>>`                                            | Left            |
| Fractions      | `//`                                                   | Left            |
| Multiplication | `* / % & \ ÷`                                          | Left[^2]        |
| Addition       | `+ - \| ⊻`                                             | Left[^2]        |
| Syntax         | `: ..`                                                 | Left            |
| Syntax         | `\|>`                                                  | Left            |
| Syntax         | `<\|`                                                  | Right           |
| Comparisons    | `> < >= <= == === != !== <:`                           | Non-associative |
| Control flow   | `&&` followed by `\|\|` followed by `?`                | Right           |
| Pair           | `=>`                                                   | Right           |
| Assignments    | `= += -= *= /= //= \= ^= ÷= %= \|= &= ⊻= <<= >>= >>>=` | Right           |

[^1]: The unary operators `+` and `-` require explicit parentheses around their argument to disambiguate them from the operator `++`, etc. Other compositions of unary operators are parsed with right-associativity, e. g., `√√-a` as `√(√(-a))`.

[^2]: The operators `+`, `++` and `*` are non-associative. `a + b + c` is parsed as `+(a, b, c)` not `+(+(a, b), c)`. However, the fallback methods for `+(a, b, c, d...)` and `*(a, b, c, d...)` both default to left-associative evaluation.

完全な*すべての*Julia演算子の優先順位のリストについては、このファイルの先頭を参照してください: [`src/julia-parser.scm`](https://github.com/JuliaLang/julia/blob/master/src/julia-parser.scm)。そこにある演算子の中には、`Base`モジュールで定義されていないものもありますが、標準ライブラリ、パッケージ、またはユーザーコードによって定義される場合があります。

任意の演算子の数値的優先順位は、組み込み関数 `Base.operator_precedence` を介しても見つけることができ、高い数値が優先されます：

```jldoctest
julia> Base.operator_precedence(:+), Base.operator_precedence(:*), Base.operator_precedence(:.)
(11, 12, 17)

julia> Base.operator_precedence(:sin), Base.operator_precedence(:+=), Base.operator_precedence(:(=))  # (Note the necessary parens on `:(=)`)
(0, 1, 1)
```

演算子の結合性を表すシンボルは、組み込み関数 `Base.operator_associativity` を呼び出すことでも見つけることができます:

```jldoctest
julia> Base.operator_associativity(:-), Base.operator_associativity(:+), Base.operator_associativity(:^)
(:left, :none, :right)

julia> Base.operator_associativity(:⊗), Base.operator_associativity(:sin), Base.operator_associativity(:→)
(:left, :none, :right)
```

記号 `:sin` は優先順位 `0` を返すことに注意してください。この値は無効な演算子を表し、最も低い優先順位の演算子ではありません。同様に、そのような演算子には結合性 `:none` が割り当てられます。

[Numeric literal coefficients](@ref man-numeric-literal-coefficients)、例えば `2x` は、他のすべての二項演算よりも高い優先順位で乗算として扱われます。ただし、`^` の場合は、指数としてのみ高い優先順位を持ちます。

```jldoctest
julia> x = 3; 2x^2
18

julia> x = 3; 2^2x
64
```

対置は一項演算子のように解析され、指数に関して同じ自然な非対称性を持っています：`-x^y` と `2x^y` は `-(x^y)` と `2(x^y)` として解析されるのに対し、`x^-y` と `x^2y` は `x^(-y)` と `x^(2y)` として解析されます。

## Numerical Conversions

Juliaは、近似変換の扱いが異なる3つの数値変換形式をサポートしています。

  * `T(x)` または `convert(T, x)` の表記は、`x` を型 `T` の値に変換します。

      * `T`が浮動小数点型である場合、結果は最も近い表現可能な値であり、それは正の無限大または負の無限大である可能性があります。
      * `T`が整数型である場合、`x`が`T`で表現できない場合は`InexactError`が発生します。
  * `x % T` は整数 `x` を整数型 `T` の値に変換し、`x` を `2^n` で割った余りと同じ値になります。ここで、`n` は `T` のビット数です。言い換えれば、バイナリ表現はフィットするように切り捨てられます。
  * [Rounding functions](@ref) は、型 `T` をオプションの引数として受け取ります。例えば、`round(Int,x)` は `Int(round(x))` の省略形です。

以下の例は、さまざまな形式を示しています。

```jldoctest
julia> Int8(127)
127

julia> Int8(128)
ERROR: InexactError: trunc(Int8, 128)
Stacktrace:
[...]

julia> Int8(127.0)
127

julia> Int8(3.14)
ERROR: InexactError: Int8(3.14)
Stacktrace:
[...]

julia> Int8(128.0)
ERROR: InexactError: Int8(128.0)
Stacktrace:
[...]

julia> 127 % Int8
127

julia> 128 % Int8
-128

julia> round(Int8,127.4)
127

julia> round(Int8,127.6)
ERROR: InexactError: Int8(128.0)
Stacktrace:
[...]
```

[Conversion and Promotion](@ref conversion-and-promotion)を参照して、自分自身の変換とプロモーションを定義する方法を確認してください。

### Rounding functions

| Function              | Description                      | Return type |
|:--------------------- |:-------------------------------- |:----------- |
| [`round(x)`](@ref)    | round `x` to the nearest integer | `typeof(x)` |
| [`round(T, x)`](@ref) | round `x` to the nearest integer | `T`         |
| [`floor(x)`](@ref)    | round `x` towards `-Inf`         | `typeof(x)` |
| [`floor(T, x)`](@ref) | round `x` towards `-Inf`         | `T`         |
| [`ceil(x)`](@ref)     | round `x` towards `+Inf`         | `typeof(x)` |
| [`ceil(T, x)`](@ref)  | round `x` towards `+Inf`         | `T`         |
| [`trunc(x)`](@ref)    | round `x` towards zero           | `typeof(x)` |
| [`trunc(T, x)`](@ref) | round `x` towards zero           | `T`         |

### Division functions

| Function                   | Description                                                                                               |
|:-------------------------- |:--------------------------------------------------------------------------------------------------------- |
| [`div(x, y)`](@ref), `x÷y` | truncated division; quotient rounded towards zero                                                         |
| [`fld(x, y)`](@ref)        | floored division; quotient rounded towards `-Inf`                                                         |
| [`cld(x, y)`](@ref)        | ceiling division; quotient rounded towards `+Inf`                                                         |
| [`rem(x, y)`](@ref), `x%y` | remainder; satisfies `x == div(x, y)*y + rem(x, y)`; sign matches `x`                                     |
| [`mod(x, y)`](@ref)        | modulus; satisfies `x == fld(x, y)*y + mod(x, y)`; sign matches `y`                                       |
| [`mod1(x, y)`](@ref)       | `mod` with offset 1; returns `r∈(0, y]` for `y>0` or `r∈[y, 0)` for `y<0`, where `mod(r, y) == mod(x, y)` |
| [`mod2pi(x)`](@ref)        | modulus with respect to 2pi;  `0 <= mod2pi(x) < 2pi`                                                      |
| [`divrem(x, y)`](@ref)     | returns `(div(x, y),rem(x, y))`                                                                           |
| [`fldmod(x, y)`](@ref)     | returns `(fld(x, y), mod(x, y))`                                                                          |
| [`gcd(x, y...)`](@ref)     | greatest positive common divisor of `x`, `y`,...                                                          |
| [`lcm(x, y...)`](@ref)     | least positive common multiple of `x`, `y`,...                                                            |

### Sign and absolute value functions

| Function                 | Description                                                |
|:------------------------ |:---------------------------------------------------------- |
| [`abs(x)`](@ref)         | a positive value with the magnitude of `x`                 |
| [`abs2(x)`](@ref)        | the squared magnitude of `x`                               |
| [`sign(x)`](@ref)        | indicates the sign of `x`, returning -1, 0, or +1          |
| [`signbit(x)`](@ref)     | indicates whether the sign bit is on (true) or off (false) |
| [`copysign(x, y)`](@ref) | a value with the magnitude of `x` and the sign of `y`      |
| [`flipsign(x, y)`](@ref) | a value with the magnitude of `x` and the sign of `x*y`    |

### Powers, logs and roots

| Function                      | Description                                                                |
|:----------------------------- |:-------------------------------------------------------------------------- |
| [`sqrt(x)`](@ref), `√x`       | square root of `x`                                                         |
| [`cbrt(x)`](@ref), `∛x`       | cube root of `x`                                                           |
| [`fourthroot(x)`](@ref), `∜x` | fourth root of `x`                                                         |
| [`hypot(x, y)`](@ref)         | hypotenuse of right-angled triangle with other sides of length `x` and `y` |
| [`exp(x)`](@ref)              | natural exponential function at `x`                                        |
| [`expm1(x)`](@ref)            | accurate `exp(x) - 1` for `x` near zero                                    |
| [`ldexp(x, n)`](@ref)         | `x * 2^n` computed efficiently for integer values of `n`                   |
| [`log(x)`](@ref)              | natural logarithm of `x`                                                   |
| [`log(b, x)`](@ref)           | base `b` logarithm of `x`                                                  |
| [`log2(x)`](@ref)             | base 2 logarithm of `x`                                                    |
| [`log10(x)`](@ref)            | base 10 logarithm of `x`                                                   |
| [`log1p(x)`](@ref)            | accurate `log(1 + x)` for `x` near zero                                    |
| [`exponent(x)`](@ref)         | binary exponent of `x`                                                     |
| [`significand(x)`](@ref)      | binary significand (a.k.a. mantissa) of a floating-point number `x`        |

関数 [`hypot`](@ref)、[`expm1`](@ref)、および [`log1p`](@ref) がなぜ必要で有用であるかの概要については、John D. Cook のこのテーマに関する優れたブログ記事のペアを参照してください: [expm1, log1p, erfc](https://www.johndcook.com/blog/2010/06/07/math-library-functions-that-seem-unnecessary/)、および [hypot](https://www.johndcook.com/blog/2010/06/02/whats-so-hard-about-finding-a-hypotenuse/)。

### Trigonometric and hyperbolic functions

すべての標準三角関数および双曲線関数も定義されています：

```
sin    cos    tan    cot    sec    csc
sinh   cosh   tanh   coth   sech   csch
asin   acos   atan   acot   asec   acsc
asinh  acosh  atanh  acoth  asech  acsch
sinc   cosc
```

これらはすべて単一引数の関数であり、[`atan`](@ref) は、従来の [`atan2`](https://en.wikipedia.org/wiki/Atan2) 関数に対応する2つの引数も受け入れます。

さらに、[`sinpi(x)`](@ref) と [`cospi(x)`](@ref) は、それぞれ [`sin(pi * x)`](@ref) と [`cos(pi * x)`](@ref) のより正確な計算のために提供されています。

度数で三角関数を計算するには、関数の後に `d` を付けます。例えば、 [`sind(x)`](@ref) は、 `x` が度数で指定される場合の `x` の正弦を計算します。度数バリアントを持つ三角関数の完全なリストは次のとおりです：

```
sind   cosd   tand   cotd   secd   cscd
asind  acosd  atand  acotd  asecd  acscd
```

### Special functions

パッケージ [SpecialFunctions.jl](https://github.com/JuliaMath/SpecialFunctions.jl) によって、多くの他の特別な数学関数が提供されています。
