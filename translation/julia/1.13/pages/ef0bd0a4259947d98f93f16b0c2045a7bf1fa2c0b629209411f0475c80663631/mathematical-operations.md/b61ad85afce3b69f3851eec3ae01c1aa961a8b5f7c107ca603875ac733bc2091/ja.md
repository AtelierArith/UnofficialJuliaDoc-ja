# Mathematical Operations and Elementary Functions

Julia には、すべての基本数値型に対する基本的な算術演算子とビット演算子が一通り揃っています。また、標準的な数学関数も幅広く提供しており、移植性と効率性に優れた実装が用意されています。

## Arithmetic Operators

次の[arithmetic operators](https://en.wikipedia.org/wiki/Arithmetic#Arithmetic_operations)は、すべての基本数値型で使用できます。

| 式       | 名前     | 説明              |
|:------- |:------ |:--------------- |
| `+x`    | 単項プラス  | 恒等演算            |
| `-x`    | 単項マイナス | 値を加法逆元に写す       |
| `x + y` | 二項プラス  | 加算を行う           |
| `x - y` | 二項マイナス | 減算を行う           |
| `x * y` | 乗算     | 乗算を行う           |
| `x / y` | 除算     | 除算を行う           |
| `x ÷ y` | 整数除算   | x / y を整数に切り捨てる |
| `x \ y` | 逆除算    | `y / x`と同等      |
| `x ^ y` | べき乗    | `x`を`y`乗する      |
| `x % y` | 剰余     | `rem(x, y)`と同等  |

数値リテラルを識別子や括弧の直前に置くと（例：`2x`、`2(x + y)`）、乗算として扱われます。ただし、他の二項演算子より優先順位が高くなります。詳しくは[Numeric Literal Coefficients](@ref man-numeric-literal-coefficients)を参照してください。

Julia の型昇格システムにより、異なる型の引数が混在する算術演算も、自然かつ自動的に処理されます。型昇格システムの詳細は[Conversion and Promotion](@ref conversion-and-promotion)を参照してください。

÷記号は、REPL または Julia IDE で`\div<tab>`と入力すると簡単に入力できます。詳しくは[manual section on Unicode input](@ref Unicode-Input)を参照してください。

算術演算子の簡単な使用例を示します。

```jldoctest
julia> 1 + 2 + 3
6

julia> 1 - 2
-1

julia> 3*2/12
0.5
```

（慣例として、近くにある他の演算子より先に適用される演算子は、間隔を詰めて書くことが多いです。たとえば、まず`x`を否定し、その結果に`2`を加えることを表すため、通常は`-x + 2`と書きます。）

## Boolean Operators

次の[Boolean operators](https://en.wikipedia.org/wiki/Boolean_algebra#Operations)は、[`Bool`](@ref)型で使用できます。

| 式          | 名前                                                      |
|:---------- |:------------------------------------------------------- |
| `!x`       | 否定                                                      |
| `x && y`   | [short-circuiting and](@ref man-conditional-evaluation) |
| `x \|\| y` | [short-circuiting or](@ref man-conditional-evaluation)  |

否定演算は、`true`を`false`に、またその逆に変換します。短絡評価を行う演算については、リンク先のページで説明しています。

## Arithmetic operations with `Bool` values

`Bool`は整数型です。そのため、`false`は数値として`0`と等しく、`true`は数値として`1`と等しくなります。通常の型昇格規則と数値演算子もすべて定義されていますが、引数がすべて`Bool`の場合、算術演算（ブール演算以外）には特別な動作があります。この場合、引数の型はそのまま維持されず、`Int`に昇格されます。たとえば、`Bool`を使った演算と、別の数値型（`UInt8`）を使った同等の演算を比較してみましょう。

```jldoctest
julia> true - true
0

julia> 0x01 - 0x01
0x00
```

また、乗算に使う場合、`false`は*強いゼロ*として振る舞います。

```jldoctest
julia> NaN * false
0.0

julia> false * Inf
0.0
```

これは、ゼロであることが分かっている量に`NaN`の値が伝播するのを防ぐのに役立ちます。この動作の背景については[Knuth (1992)](https://arxiv.org/abs/math/9205211)を参照してください。

## Bitwise Operators

次の[bitwise operators](https://en.wikipedia.org/wiki/Bitwise_operation#Bitwise_operators)は、すべての基本整数型で使用できます。

| 式         | 名前                                                                     |
|:--------- |:---------------------------------------------------------------------- |
| `~x`      | ビット否定                                                                  |
| `x & y`   | ビット論理積                                                                 |
| `x \| y`  | ビット論理和                                                                 |
| `x ⊻ y`   | ビット排他的論理和（XOR）                                                         |
| `x ⊼ y`   | ビット否定論理積（NAND）                                                         |
| `x ⊽ y`   | ビット否定論理和（NOR）                                                          |
| `x >>> y` | [logical shift](https://en.wikipedia.org/wiki/Logical_shift)右シフト       |
| `x >> y`  | [arithmetic shift](https://en.wikipedia.org/wiki/Arithmetic_shift)右シフト |
| `x << y`  | 論理／算術左シフト                                                              |

ビット演算子の使用例を示します。

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

すべての二項算術演算子とビット演算子には、演算結果を左辺のオペランドに代入する更新版もあります。二項演算子の直後に`=`を置くと、更新版になります。たとえば、`x += 3`と書くことは、`x = x + 3`と書くことと同等です。

```jldoctest
julia> x = 1
1

julia> x += 3
4

julia> x
4
```

すべての二項算術演算子とビット演算子の更新版は次のとおりです。

```
+=  -=  *=  /=  \=  ÷=  %=  ^=  &=  |=  ⊻=  >>>=  >>=  <<=
```

!!! note
    更新演算子は左辺の変数を再束縛します。そのため、変数の型が変わることがあります。

    ```jldoctest
    julia> x = 0x01; typeof(x)
    UInt8

    julia> x *= 2 # Same as x = x * 2
    2

    julia> typeof(x)
    Int64
    ```


## [Vectorized "dot" operators](@id man-dot-operators)

`^`のような*すべての*二項演算には、対応する「ドット」演算`.^`があります。これは、配列の各要素に対して`^`を自動的に実行するよう定義されています。たとえば、（正方形でない）配列の「3乗」には標準的な数学上の意味がないため、`[1, 2, 3] ^ 3`は定義されていません。一方、`[1, 2, 3] .^ 3`は、要素ごとの（または「ベクトル化された」）結果`[1^3, 2^3, 3^3]`を計算するものとして定義されています。`!`や`√`のような単項演算子にも、各要素に演算子を適用する対応する`.√`があります。

```jldoctest
julia> [1, 2, 3] .^ 3
3-element Vector{Int64}:
  1
  8
 27
```

より具体的には、`a .^ b`は["dot" call](@ref man-vectorized) `(^).(a,b)`として構文解析され、[broadcast](@ref Broadcasting)演算を行います。配列とスカラー、同じサイズの配列（要素ごとに演算）、さらには形状の異なる配列（たとえば、行ベクトルと列ベクトルを組み合わせて行列を生成する場合）も扱えます。また、ベクトル化された「ドット呼び出し」と同様に、これらの「ドット演算子」は*融合*されます。たとえば、配列`A`に対して`2 .* A.^2 .+ sin.(A)`を計算すると（または[`@.`](@ref @__dot__)マクロを使って`@. 2A^2 + sin(A)`と書くと）、`A`を一度だけ走査し、`A`の各要素`a`について`2a^2 + sin(a)`を計算します。特に、`f.(g.(x))`のような入れ子のドット呼び出しは融合されます。また、`x .+ 3 .* x.^2`のように隣接する二項演算子を並べた式は、入れ子のドット呼び出し`(+).(x, (*).(3, (^).(x, 2)))`と同等です。

さらに、`a .+= b`（または`@. a += b`）のような「ドット付き」更新演算子は、`a .= a .+ b`として構文解析されます。ここで`.=`は、融合された*インプレース*代入演算です（[dot syntax documentation](@ref man-vectorized)を参照）。

ドット構文は、ユーザー定義演算子にも適用できます。たとえば、クロネッカー積（[`kron`](@ref)）を表す便利な中置記法`A ⊗ B`として`⊗(A, B) = kron(A, B)`を定義すれば、追加のコードを書くことなく、`[A, B] .⊗ [C, D]`で`[A⊗C, B⊗D]`を計算できます。

ドット演算子と数値リテラルを組み合わせると、解釈が曖昧になることがあります。たとえば、`1.+x`が`1. + x`を意味するのか、`1 .+ x`を意味するのかは明確ではありません。そのため、この構文は使用できません。このような場合は、演算子の前後に空白を入れる必要があります。

## Numeric Comparisons

すべての基本数値型に、標準的な比較演算が定義されています。

| 演算子                          | 名前    |
|:---------------------------- |:----- |
| [`==`](@ref)                 | 等しい   |
| [`!=`](@ref), [`≠`](@ref !=) | 等しくない |
| [`<`](@ref)                  | より小さい |
| [`<=`](@ref), [`≤`](@ref <=) | 以下    |
| [`>`](@ref)                  | より大きい |
| [`>=`](@ref), [`≥`](@ref >=) | 以上    |

簡単な例を示します。

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

整数は、ビットを比較する標準的な方法で比較されます。浮動小数点数は、[IEEE 754 standard](https://en.wikipedia.org/wiki/IEEE_754-2008)に従って比較されます。

  * 有限数は通常の順序で比較されます。
  * 正のゼロは負のゼロと等しく、負のゼロより大きくはありません。
  * `Inf`は自身と等しく、`NaN`を除くすべての値より大きくなります。
  * `-Inf`は自身と等しく、`NaN`を除くすべての値より小さくなります。
  * `NaN`は、自身を含むどの値とも等しくなく、どの値よりも小さくも大きくもありません。

最後の点は意外に思われるかもしれないため、注意が必要です。

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

この性質は、[arrays](@ref man-multi-dim-arrays)を扱う際に問題を引き起こすことがあります。

```jldoctest
julia> [1 NaN] == [1 NaN]
false
```

Julia には、特殊な値かどうかを調べる関数も用意されています。ハッシュキーの比較などに役立ちます。

| 関数                      | 判定内容        |
|:----------------------- |:----------- |
| [`isequal(x, y)`](@ref) | `x`と`y`が同一か |
| [`isfinite(x)`](@ref)   | `x`が有限数か    |
| [`isinf(x)`](@ref)      | `x`が無限大か    |
| [`isnan(x)`](@ref)      | `x`が数値でないか  |

[`isequal`](@ref)では、`NaN`同士は等しいとみなされます。

```jldoctest
julia> isequal(NaN, NaN)
true

julia> isequal([1 NaN], [1 NaN])
true

julia> isequal(NaN, NaN32)
true
```

`isequal`を使うと、符号付きゼロを区別することもできます。

```jldoctest
julia> -0.0 == 0.0
true

julia> isequal(-0.0, 0.0)
false
```

符号付き整数、符号なし整数、浮動小数点数の間で型が混在する比較は、扱いが難しい場合があります。Julia では、これらを正しく比較できるよう細心の注意が払われています。

その他の型では、`isequal`は既定で[`==`](@ref)を呼び出します。そのため、独自の型に等価性を定義するには、[`==`](@ref)メソッドを追加するだけで十分です。独自の等価性関数を定義する場合は、`isequal(x,y)`ならば`hash(x) == hash(y)`となることを保証するため、対応する[`hash`](@ref)メソッドも定義するとよいでしょう。

### Chaining comparisons

多くの言語とは異なり、[notable exception of Python](https://en.wikipedia.org/wiki/Python_syntax_and_semantics#Comparison_operators)では比較を任意の長さで連鎖できます。

```jldoctest
julia> 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
true
```

比較の連鎖は、数値計算のコードで便利なことがよくあります。連鎖比較では、スカラーの比較に`&&`演算子を使い、要素ごとの比較には[`&`](@ref)演算子を使うため、配列にも適用できます。たとえば、`0 .< A .< 1`は、`A`の対応する要素が0から1の範囲にある箇所でtrueとなる、ブール値の配列を返します。

連鎖比較の評価動作にも注意してください。

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

中央の式は一度だけ評価されます。`v(1) < v(2) && v(2) <= v(3)`のように書いた場合のように、二度評価されることはありません。ただし、連鎖比較における評価順序は未定義です。表示などの副作用を伴う式を連鎖比較に含めることは、強く推奨されません。副作用が必要な場合は、短絡評価を行う`&&`演算子を明示的に使ってください（[Short-Circuit Evaluation](@ref)を参照）。

### Elementary Functions

Julia には、数学関数と演算子が幅広く揃っています。これらの数学演算は、意味のある定義が可能な限り、整数、浮動小数点数、有理数、複素数など、幅広い数値に対して定義されています。

また、これらの関数は（Julia の他の関数と同様に）、[dot syntax](@ref man-vectorized) `f.(A)`を使って、配列やその他のコレクションに「ベクトル化」して適用できます。たとえば、`sin.(A)`は、配列`A`の各要素の正弦を計算します。

## Operator Precedence and Associativity

Julia では、演算の優先順位が高いものから低いものへ、次の順序と結合規則が適用されます。

| カテゴリ   | 演算子                                                    | 結合規則    |
|:------ |:------------------------------------------------------ |:------- |
| 構文     | `.`の後に`::`                                             | 左結合     |
| べき乗    | `^`                                                    | 右結合     |
| 単項演算   | `+ - ! ~ ¬ √ ∛ ∜ ⋆ ± ∓ <: >:`                          | 右結合[^1] |
| ビットシフト | `<< >> >>>`                                            | 左結合     |
| 分数演算   | `//`                                                   | 左結合     |
| 乗算     | `* / % & \ ÷`                                          | 左結合[^2] |
| 加算     | `+ - \| ⊻`                                             | 左結合[^2] |
| 構文     | `: ..`                                                 | 左結合     |
| 構文     | `\|>`                                                  | 左結合     |
| 構文     | `<\|`                                                  | 右結合     |
| 比較     | `> < >= <= == === != !== <:`                           | 非結合     |
| 制御フロー  | `&&`の後に`\|\|`、さらに`?`                                   | 右結合     |
| ペア     | `=>`                                                   | 右結合     |
| 代入     | `= += -= *= /= //= \= ^= ÷= %= \|= &= ⊻= <<= >>= >>>=` | 右結合     |

[^1]: 単項演算子`+`と`-`では、演算子`++`などとの曖昧さを避けるため、引数を明示的に括弧で囲む必要があります。その他の単項演算子の組み合わせは右結合として構文解析されます。たとえば、`√√-a`は`√(√(-a))`として解析されます。

[^2]: 演算子`+`、`++`、`*`は非結合です。`a + b + c`は`+(a, b, c)`として解析され、`+(+(a, b), c)`としては解析されません。ただし、`+(a, b, c, d...)`と`*(a, b, c, d...)`のフォールバックメソッドは、どちらも既定で左結合の評価を行います。

Julia の*すべての*演算子の優先順位については、このファイルの冒頭にある一覧を参照してください。[`src/julia-parser.scm`](https://github.com/JuliaLang/julia/blob/master/src/julia-parser.scm)なお、一覧にある演算子の中には、`Base`モジュールでは定義されていないものもありますが、標準ライブラリ、パッケージ、またはユーザーコードで定義される場合があります。

組み込み関数`Base.operator_precedence`を使うと、任意の演算子の数値としての優先順位も確認できます。数値が大きいほど優先順位が高くなります。

```jldoctest
julia> Base.operator_precedence(:+), Base.operator_precedence(:*), Base.operator_precedence(:.)
(11, 12, 17)

julia> Base.operator_precedence(:sin), Base.operator_precedence(:+=), Base.operator_precedence(:(=))  # (Note the necessary parens on `:(=)`)
(0, 1, 1)
```

組み込み関数`Base.operator_associativity`を呼び出すと、演算子の結合規則を表すシンボルも取得できます。

```jldoctest
julia> Base.operator_associativity(:-), Base.operator_associativity(:+), Base.operator_associativity(:^)
(:left, :none, :right)

julia> Base.operator_associativity(:⊗), Base.operator_associativity(:sin), Base.operator_associativity(:→)
(:left, :none, :right)
```

`:sin`のようなシンボルは、優先順位として`0`を返します。この値は無効な演算子を表すものであり、優先順位が最も低い演算子を表すものではありません。同様に、このような演算子には`:none`という結合規則が割り当てられます。

[Numeric literal coefficients](@ref man-numeric-literal-coefficients)（たとえば`2x`）は、他の二項演算より優先順位の高い乗算として扱われます。ただし`^`の場合は例外で、指数として使われる場合に限り、より高い優先順位になります。

```jldoctest
julia> x = 3; 2x^2
18

julia> x = 3; 2^2x
64
```

並置は単項演算子のように構文解析されます。指数との関係も同様に非対称で、`-x^y`と`2x^y`はそれぞれ`-(x^y)`と`2(x^y)`として解析されます。一方、`x^-y`と`x^2y`はそれぞれ`x^(-y)`と`x^(2y)`として解析されます。

## Numerical Conversions

Julia には、正確に表現できない変換の扱いが異なる、数値変換の形式が3種類あります。

  * `T(x)`または`convert(T, x)`という記法は、`x`を型`T`の値に変換します。

      * `T`が浮動小数点型の場合、結果は表現可能な最も近い値になります。正または負の無限大になることもあります。
      * `T`が整数型の場合、`x`を`T`で表現できなければ、`InexactError`が発生します。
  * `x % T`は、整数`x`を、`x`と法`2^n`で合同な整数型`T`の値に変換します。ここで`n`は、`T`のビット数です。つまり、二進表現を切り詰めて収まるようにします。
  * [Rounding functions](@ref)では、型`T`を省略可能な引数として指定できます。たとえば、`round(Int,x)`は`Int(round(x))`の省略記法です。

次の例で、各形式の違いを示します。

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

独自の変換や型昇格を定義する方法については、[Conversion and Promotion](@ref conversion-and-promotion)を参照してください。

### Rounding functions

| 関数                    | 説明                | 戻り値の型       |
|:--------------------- |:----------------- |:----------- |
| [`round(x)`](@ref)    | `x`を最も近い整数に丸める    | `typeof(x)` |
| [`round(T, x)`](@ref) | `x`を最も近い整数に丸める    | `T`         |
| [`floor(x)`](@ref)    | `x`を`-Inf`の方向に丸める | `typeof(x)` |
| [`floor(T, x)`](@ref) | `x`を`-Inf`の方向に丸める | `T`         |
| [`ceil(x)`](@ref)     | `x`を`+Inf`の方向に丸める | `typeof(x)` |
| [`ceil(T, x)`](@ref)  | `x`を`+Inf`の方向に丸める | `T`         |
| [`trunc(x)`](@ref)    | `x`をゼロ方向に丸める      | `typeof(x)` |
| [`trunc(T, x)`](@ref) | `x`をゼロ方向に丸める      | `T`         |

### Division functions

| 関数                         | 説明                                                                                        |
|:-------------------------- |:----------------------------------------------------------------------------------------- |
| [`div(x, y)`](@ref), `x÷y` | 商をゼロ方向に丸める、切り捨て除算                                                                         |
| [`fld(x, y)`](@ref)        | 商を`-Inf`方向に丸める、床関数による除算                                                                   |
| [`cld(x, y)`](@ref)        | 商を`+Inf`方向に丸める、天井関数による除算                                                                  |
| [`rem(x, y)`](@ref), `x%y` | 剰余。`x == div(x, y)*y + rem(x, y)`を満たし、符号は`x`と一致                                           |
| [`mod(x, y)`](@ref)        | 法。`x == fld(x, y)*y + mod(x, y)`を満たし、符号は`y`と一致                                            |
| [`mod1(x, y)`](@ref)       | オフセット1の`mod`。`y>0`または`y<0`に対して、それぞれ`r∈(0, y]`または`r∈[y, 0)`を返す。ここで`mod(r, y) == mod(x, y)` |
| [`mod2pi(x)`](@ref)        | 2πを法とする剰余。`0 <= mod2pi(x) < 2pi`                                                          |
| [`divrem(x, y)`](@ref)     | `(div(x, y),rem(x, y))`を返す                                                                |
| [`fldmod(x, y)`](@ref)     | `(fld(x, y), mod(x, y))`を返す                                                               |
| [`gcd(x, y...)`](@ref)     | `x`、`y`、…の最大公約数                                                                           |
| [`lcm(x, y...)`](@ref)     | `x`、`y`、…の最小公倍数                                                                           |

### Sign and absolute value functions

| 関数                       | 説明                           |
|:------------------------ |:---------------------------- |
| [`abs(x)`](@ref)         | `x`と同じ大きさの正の値                |
| [`abs2(x)`](@ref)        | `x`の絶対値の二乗                   |
| [`sign(x)`](@ref)        | `x`の符号を示し、-1、0、+1を返す         |
| [`signbit(x)`](@ref)     | 符号ビットがオン（true）かオフ（false）かを示す |
| [`copysign(x, y)`](@ref) | 大きさが`x`、符号が`y`の値             |
| [`flipsign(x, y)`](@ref) | 大きさが`x`、符号が`x*y`の値           |

### Powers, logs and roots

| 関数                            | 説明                           |
|:----------------------------- |:---------------------------- |
| [`sqrt(x)`](@ref), `√x`       | `x`の平方根                      |
| [`cbrt(x)`](@ref), `∛x`       | `x`の立方根                      |
| [`fourthroot(x)`](@ref), `∜x` | `x`の4乗根                      |
| [`hypot(x, y)`](@ref)         | 他の2辺の長さが`x`と`y`である直角三角形の斜辺   |
| [`exp(x)`](@ref)              | `x`における自然指数関数                |
| [`expm1(x)`](@ref)            | 0付近の`x`に対する高精度な`exp(x) - 1`  |
| [`ldexp(x, n)`](@ref)         | `n`が整数の場合に効率よく計算される`x * 2^n` |
| [`log(x)`](@ref)              | `x`の自然対数                     |
| [`log(b, x)`](@ref)           | 底が`b`の、`x`の対数                |
| [`log2(x)`](@ref)             | `x`の2を底とする対数                 |
| [`log10(x)`](@ref)            | `x`の10を底とする対数                |
| [`log1p(x)`](@ref)            | 0付近の`x`に対する高精度な`log(1 + x)`  |
| [`exponent(x)`](@ref)         | `x`の2進指数                     |
| [`significand(x)`](@ref)      | 浮動小数点数`x`の2進仮数（マンティッサ）       |

[`hypot`](@ref)、[`expm1`](@ref)、[`log1p`](@ref)のような関数がなぜ必要で、どのように役立つのかについては、John D. Cook による優れたブログ記事2本を参照してください。[expm1, log1p, erfc](https://www.johndcook.com/blog/2010/06/07/math-library-functions-that-seem-unnecessary/)および[hypot](https://www.johndcook.com/blog/2010/06/02/whats-so-hard-about-finding-a-hypotenuse/)。

### Trigonometric and hyperbolic functions

標準的な三角関数と双曲線関数もすべて定義されています。

```
sin    cos    tan    cot    sec    csc
sinh   cosh   tanh   coth   sech   csch
asin   acos   atan   acot   asec   acsc
asinh  acosh  atanh  acoth  asech  acsch
sinc   cosc
```

これらはすべて引数を1つ取る関数です。ただし[`atan`](@ref)は、従来の[`atan2`](https://en.wikipedia.org/wiki/Atan2)関数に対応する2つの引数も受け取ります。

また、[`sin(pi * x)`](@ref)と[`cos(pi * x)`](@ref)をより高精度に計算するため、[`sinpi(x)`](@ref)と[`cospi(x)`](@ref)も用意されています。

ラジアンではなく度数法で三角関数を計算するには、関数名の末尾に`d`を付けます。たとえば、[`sind(x)`](@ref)は、`x`を度数法で指定した`x`の正弦を計算します。度数法に対応する三角関数は次のとおりです。

```
sind   cosd   tand   cotd   secd   cscd
asind  acosd  atand  acotd  asecd  acscd
```

### Special functions

その他にも、多くの特殊数学関数がパッケージ[SpecialFunctions.jl](https://github.com/JuliaMath/SpecialFunctions.jl)で提供されています。
