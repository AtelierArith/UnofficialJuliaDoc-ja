# Integers and Floating-Point Numbers

整数と浮動小数点数は、算術演算や計算の基本的な構成要素です。これらの値の組み込み表現を数値プリミティブと呼び、コード内で整数や浮動小数点数を即値として表記したものを数値リテラルと呼びます。たとえば、`1` は整数リテラルであり、`1.0` は浮動小数点リテラルです。これらをオブジェクトとしてメモリ内に格納したときのバイナリ表現が数値プリミティブです。

Julia は幅広いプリミティブ数値型を提供しており、それらに対して算術演算子、ビット演算子、標準的な数学関数が一通り定義されています。これらは現代のコンピューターがネイティブにサポートする数値型と演算に直接対応しているため、Julia は計算資源を最大限に活用できます。また、Julia は [Arbitrary Precision Arithmetic](@ref) をソフトウェアでサポートしています。これにより、ハードウェアのネイティブな表現では適切に表せない数値の演算も扱えますが、処理速度は比較的遅くなります。

Julia のプリミティブ数値型は次のとおりです。

  * **整数型：**

| 型                 | 符号付き？ | ビット数 | 最小値         | 最大値        |
|:----------------- |:----- |:---- |:----------- |:---------- |
| [`Int8`](@ref)    | ✓     | 8    | -2^7        | 2^7 - 1    |
| [`UInt8`](@ref)   |       | 8    | 0           | 2^8 - 1    |
| [`Int16`](@ref)   | ✓     | 16   | -2^15       | 2^15 - 1   |
| [`UInt16`](@ref)  |       | 16   | 0           | 2^16 - 1   |
| [`Int32`](@ref)   | ✓     | 32   | -2^31       | 2^31 - 1   |
| [`UInt32`](@ref)  |       | 32   | 0           | 2^32 - 1   |
| [`Int64`](@ref)   | ✓     | 64   | -2^63       | 2^63 - 1   |
| [`UInt64`](@ref)  |       | 64   | 0           | 2^64 - 1   |
| [`Int128`](@ref)  | ✓     | 128  | -2^127      | 2^127 - 1  |
| [`UInt128`](@ref) |       | 128  | 0           | 2^128 - 1  |
| [`Bool`](@ref)    | 該当なし  | 8    | `false` (0) | `true` (1) |

  * **浮動小数点型：**

| 型                 | 精度                                                                             | ビット数 |
|:----------------- |:------------------------------------------------------------------------------ |:---- |
| [`Float16`](@ref) | [half](https://en.wikipedia.org/wiki/Half-precision_floating-point_format)     | 16   |
| [`Float32`](@ref) | [single](https://en.wikipedia.org/wiki/Single_precision_floating-point_format) | 32   |
| [`Float64`](@ref) | [double](https://en.wikipedia.org/wiki/Double_precision_floating-point_format) | 64   |

さらに、これらのプリミティブ数値型を基盤として、[Complex and Rational Numbers](@ref) が全面的にサポートされています。柔軟でユーザーが拡張できる [type promotion system](@ref conversion-and-promotion) により、すべての数値型は明示的なキャストなしで自然に相互運用できます。

## Integers

整数リテラルは標準的な方法で表記します。

```jldoctest
julia> 1
1

julia> 1234
1234
```

整数リテラルのデフォルトの型は、対象システムが32ビットアーキテクチャか64ビットアーキテクチャかによって異なります。

```julia-repl ; nodoctest = "Results depend on system word size"
# 32-bit system:
julia> typeof(1)
Int32

# 64-bit system:
julia> typeof(1)
Int64
```

Julia の内部変数 [`Sys.WORD_SIZE`](@ref) は、対象システムが32ビットか64ビットかを示します。

```julia-repl ; nodoctest = "Results depend on system word size"
# 32-bit system:
julia> Sys.WORD_SIZE
32

# 64-bit system:
julia> Sys.WORD_SIZE
64
```

Julia は `Int` 型と `UInt` 型も定義しています。これらはそれぞれ、システムのネイティブな符号付き整数型と符号なし整数型の別名です。

```julia-repl ; nodoctest = "Results depend on system word size"
# 32-bit system:
julia> Int
Int32
julia> UInt
UInt32

# 64-bit system:
julia> Int
Int64
julia> UInt
UInt64
```

32ビットでは表現できず、64ビットでは表現できる大きな整数リテラルは、システムの種類にかかわらず常に64ビット整数を生成します。

```jldoctest
# 32-bit or 64-bit system:
julia> typeof(3000000000)
Int64
```

符号なし整数の入出力には、接頭辞 `0x` と16進数の数字 `0-9a-f` を使います（入力には大文字の `A-F` も使えます）。符号なし整数値のサイズは、使用した16進数の桁数によって決まります。

```jldoctest
julia> x = 0x1
0x01

julia> typeof(x)
UInt8

julia> x = 0x123
0x0123

julia> typeof(x)
UInt16

julia> x = 0x1234567
0x01234567

julia> typeof(x)
UInt32

julia> x = 0x123456789abcdef
0x0123456789abcdef

julia> typeof(x)
UInt64

julia> x = 0x11112222333344445555666677778888
0x11112222333344445555666677778888

julia> typeof(x)
UInt128
```

この動作は、整数値に符号なしの16進リテラルを使う場合、単なる整数値ではなく、固定のバイト列を表すことが多いという考えに基づいています。

2進リテラルと8進リテラルもサポートされています。

```jldoctest
julia> x = 0b10
0x02

julia> typeof(x)
UInt8

julia> x = 0o010
0x08

julia> typeof(x)
UInt8

julia> x = 0x00000000000000001111222233334444
0x00000000000000001111222233334444

julia> typeof(x)
UInt128
```

16進リテラルと同様に、2進リテラルと8進リテラルも符号なし整数型を生成します。リテラルの先頭の桁が `0` でなければ、その値を格納するのに必要な最小のサイズが使われます。先頭にゼロがある場合は、同じ桁数で先頭の桁を `1` にしたリテラルを格納するのに必要な最小のサイズで決まります。つまり、次のようになります。

  * `0x1` と `0x12` は `UInt8` リテラルです。
  * `0x123` と `0x1234` は `UInt16` リテラルです。
  * `0x12345` と `0x12345678` は `UInt32` リテラルです。
  * `0x123456789` と `0x1234567890adcdef` は `UInt64` リテラルです。以下も同様です。

先頭のゼロが値に影響しない場合でも、リテラルの格納サイズを決める際には桁数に数えられます。したがって、`0x01` は `UInt8` ですが、`0x0001` は `UInt16` です。

これにより、ユーザーはサイズを制御できます。

`0x` で始まる符号なしリテラルが、`UInt128` の値として表現できないほど大きな整数を表す場合は、代わりに `BigInt` の値が構築されます。これは符号なし型ではありませんが、そのような大きな整数値を表現できる唯一の組み込み型です。

2進、8進、16進リテラルには、符号なしリテラルの直前に `-` を置くことで符号を付けられます。この場合、符号なしリテラルと同じサイズの符号なし整数が生成され、その値は元の値の2の補数になります。

```jldoctest
julia> -0x2
0xfe

julia> -0x0002
0xfffe
```

整数型などのプリミティブ数値型で表現できる最小値と最大値は、[`typemin`](@ref) 関数と [`typemax`](@ref) 関数で取得できます。

```jldoctest
julia> (typemin(Int32), typemax(Int32))
(-2147483648, 2147483647)

julia> for T in [Int8,Int16,Int32,Int64,Int128,UInt8,UInt16,UInt32,UInt64,UInt128]
           println("$(lpad(T,7)): [$(typemin(T)),$(typemax(T))]")
       end
   Int8: [-128,127]
  Int16: [-32768,32767]
  Int32: [-2147483648,2147483647]
  Int64: [-9223372036854775808,9223372036854775807]
 Int128: [-170141183460469231731687303715884105728,170141183460469231731687303715884105727]
  UInt8: [0,255]
 UInt16: [0,65535]
 UInt32: [0,4294967295]
 UInt64: [0,18446744073709551615]
UInt128: [0,340282366920938463463374607431768211455]
```

[`typemin`](@ref) と [`typemax`](@ref) が返す値は、常に引数で指定した型になります。（上の式では、[for loops](@ref man-loops)、[Strings](@ref man-strings)、[Interpolation](@ref string-interpolation) など、まだ紹介していない機能をいくつか使っていますが、プログラミングの経験がある方なら容易に理解できるでしょう。）

### Overflow behavior

Julia では、ある型で表現できる最大値を超えると、値がラップアラウンドします。

```jldoctest
julia> x = typemax(Int64)
9223372036854775807

julia> x + 1
-9223372036854775808

julia> x + 1 == typemin(Int64)
true
```

Julia の整数型による算術演算は、現代のコンピューターハードウェアにおける整数演算の特性を反映し、本質的に [modular arithmetic](https://en.wikipedia.org/wiki/Modular_arithmetic) を行います。オーバーフローの可能性がある場合は、それによって生じるラップアラウンドの影響を明示的に確認することが重要です。[`Base.Checked`](@ref) モジュールは、オーバーフローの検査を備えた一連の算術演算を提供し、オーバーフローが発生するとエラーを発生させます。いかなる場合にもオーバーフローを許容できない用途では、[Arbitrary Precision Arithmetic](@ref) で詳述されている [`BigInt`](@ref) 型の使用を推奨します。

オーバーフローの動作と、その対処方法の一例を次に示します。

```jldoctest
julia> 10^19
-8446744073709551616

julia> big(10)^19
10000000000000000000
```

### Division errors

整数除算（`div` 関数）には、ゼロによる除算と、最小の負の数（[`typemin`](@ref)）を -1 で割る場合という、2つの例外的なケースがあります。どちらの場合も [`DivideError`](@ref) が送出されます。剰余を求める関数（`rem` と `mod`）は、第2引数がゼロの場合に [`DivideError`](@ref) を送出します。

## Floating-Point Numbers

浮動小数点リテラルは標準的な形式で表記し、必要に応じて [E-notation](https://en.wikipedia.org/wiki/Scientific_notation#E_notation) を使います。

```jldoctest
julia> 1.0
1.0

julia> 1.
1.0

julia> 0.5
0.5

julia> .5
0.5

julia> -1.23
-1.23

julia> 1e10
1.0e10

julia> 2.5e-4
0.00025
```

上の結果はすべて [`Float64`](@ref) の値です。[`Float32`](@ref) のリテラル値は、`e` の代わりに `f` を書くことで入力できます。

```jldoctest
julia> x = 0.5f0
0.5f0

julia> typeof(x)
Float32

julia> 2.5f-4
0.00025f0
```

値は簡単に [`Float32`](@ref) に変換できます。

```jldoctest
julia> x = Float32(-1.5)
-1.5f0

julia> typeof(x)
Float32
```

16進浮動小数点リテラルも使用できますが、[`Float64`](@ref) の値に限られます。底を2とする指数部の前に `p` を置きます。

```jldoctest
julia> 0x1p0
1.0

julia> 0x1.8p3
12.0

julia> x = 0x.4p-1
0.125

julia> typeof(x)
Float64
```

半精度浮動小数点数（[`Float16`](@ref)）もすべてのプラットフォームでサポートされており、この数値形式をサポートするハードウェアではネイティブ命令が使われます。それ以外では、演算はソフトウェアで実装され、中間計算に [`Float32`](@ref) が使われます。内部実装では、LLVM の [`half`](https://llvm.org/docs/LangRef.html#half-precision-floating-point-intrinsics) 型を使ってこれを実現しています。この型の動作は、C/C++ コードに対する GCC の [`-fexcess-precision=16`](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html#index-fexcess-precision) フラグの動作に似ています。

```jldoctest
julia> sizeof(Float16(4.))
2

julia> 2*Float16(4.)
Float16(8.0)
```

アンダースコア `_` は、桁の区切りに使えます。

```jldoctest
julia> 10_000, 0.000_000_005, 0xdead_beef, 0b1011_0010
(10000, 5.0e-9, 0xdeadbeef, 0xb2)
```

### Floating-point zero

浮動小数点数には [two zeros](https://en.wikipedia.org/wiki/Signed_zero)、すなわち正のゼロと負のゼロがあります。これらは互いに等しいものの、バイナリ表現は異なります。これは [`bitstring`](@ref) 関数で確認できます。

```jldoctest
julia> 0.0 == -0.0
true

julia> bitstring(0.0)
"0000000000000000000000000000000000000000000000000000000000000000"

julia> bitstring(-0.0)
"1000000000000000000000000000000000000000000000000000000000000000"
```

### Special floating-point values

実数直線上のどの点にも対応しない、次の3つの標準的な浮動小数点値が規定されています。

| `Float16` | `Float32` | `Float64` | 名前    | 説明                              |
|:--------- |:--------- |:--------- |:----- |:------------------------------- |
| `Inf16`   | `Inf32`   | `Inf`     | 正の無限大 | すべての有限の浮動小数点値より大きい値             |
| `-Inf16`  | `-Inf32`  | `-Inf`    | 負の無限大 | すべての有限の浮動小数点値より小さい値             |
| `NaN16`   | `NaN32`   | `NaN`     | 非数    | どの浮動小数点値（自分自身を含む）とも `==` にならない値 |

これらの非有限の浮動小数点値どうしや、他の浮動小数点値との順序関係について詳しくは、[Numeric Comparisons](@ref) を参照してください。[IEEE 754 standard](https://en.wikipedia.org/wiki/IEEE_754-2008) に従い、これらの浮動小数点値は特定の算術演算の結果として得られます。

```jldoctest
julia> 1/Inf
0.0

julia> 1/0
Inf

julia> -5/0
-Inf

julia> 0.000001/0
Inf

julia> 0/0
NaN

julia> 500 + Inf
Inf

julia> 500 - Inf
-Inf

julia> Inf + Inf
Inf

julia> Inf - Inf
NaN

julia> Inf * Inf
Inf

julia> Inf / Inf
NaN

julia> 0 * Inf
NaN

julia> NaN == NaN
false

julia> NaN != NaN
true

julia> NaN < NaN
false

julia> NaN > NaN
false
```

[`typemin`](@ref) 関数と [`typemax`](@ref) 関数は、浮動小数点型にも適用できます。

```jldoctest
julia> (typemin(Float16),typemax(Float16))
(-Inf16, Inf16)

julia> (typemin(Float32),typemax(Float32))
(-Inf32, Inf32)

julia> (typemin(Float64),typemax(Float64))
(-Inf, Inf)
```

### Machine epsilon

ほとんどの実数は浮動小数点数で正確に表現できません。そのため、多くの用途では、表現可能な隣り合う2つの浮動小数点数の間隔を知ることが重要です。この間隔はしばしば [machine epsilon](https://en.wikipedia.org/wiki/Machine_epsilon) と呼ばれます。

Julia は [`eps`](@ref) を提供しています。これは、`1.0` と、それより大きい次の表現可能な浮動小数点値との間隔を返します。

```jldoctest
julia> eps(Float32)
1.1920929f-7

julia> eps(Float64)
2.220446049250313e-16

julia> eps() # same as eps(Float64)
2.220446049250313e-16
```

これらの値はそれぞれ、[`Float32`](@ref) の値としての `2.0^-23` と、[`Float64`](@ref) の値としての `2.0^-52` です。[`eps`](@ref) 関数は浮動小数点値を引数に取ることもでき、その値と次の表現可能な浮動小数点値との差の絶対値を返します。つまり、`eps(x)` は `x` と同じ型の値を返し、`x + eps(x)` が `x` より大きい次の表現可能な浮動小数点値となるようにします。

```jldoctest
julia> eps(1.0)
2.220446049250313e-16

julia> eps(1000.)
1.1368683772161603e-13

julia> eps(1e-27)
1.793662034335766e-43

julia> eps(0.0)
5.0e-324
```

表現可能な隣り合う2つの浮動小数点数の間隔は一定ではなく、値が小さいほど狭く、値が大きいほど広くなります。言い換えると、表現可能な浮動小数点数は実数直線上のゼロ付近で最も密になり、ゼロから離れるにつれて指数的にまばらになります。`1.0` は64ビット浮動小数点値なので、定義により `eps(1.0)` は `eps(Float64)` と同じです。

Julia は [`nextfloat`](@ref) 関数と [`prevfloat`](@ref) 関数も提供しています。これらはそれぞれ、引数より大きい次の表現可能な浮動小数点数と、引数より小さい次の表現可能な浮動小数点数を返します。

```jldoctest
julia> x = 1.25f0
1.25f0

julia> nextfloat(x)
1.2500001f0

julia> prevfloat(x)
1.2499999f0

julia> bitstring(prevfloat(x))
"00111111100111111111111111111111"

julia> bitstring(x)
"00111111101000000000000000000000"

julia> bitstring(nextfloat(x))
"00111111101000000000000000000001"
```

この例は、表現可能な隣り合う浮動小数点数は、そのバイナリ表現を整数と見なしたときにも隣り合っているという一般的な原則を示しています。

### Rounding modes

ある数を浮動小数点数で正確に表現できない場合は、適切な表現可能値に丸める必要があります。ただし、必要に応じて [IEEE 754 standard](https://en.wikipedia.org/wiki/IEEE_754-2008) に示されている丸めモードを使い、丸め方を変更できます。

デフォルトでは常に [`RoundNearest`](@ref) が使われます。これは最も近い表現可能な値に丸め、ちょうど中間にある場合は最下位ビットが偶数となる側の値に丸めます。

### Background and References

浮動小数点演算には、低水準の実装の詳細を知らないユーザーには意外に思えるような、微妙な点が数多くあります。ただし、これらは科学技術計算に関する多くの書籍や、次の参考資料で詳しく説明されています。

  * 浮動小数点演算に関する決定版の資料は [IEEE 754-2008 Standard](https://standards.ieee.org/standard/754-2008.html) ですが、オンラインで無料公開はされていません。
  * 浮動小数点数の表現について簡潔で明快な説明を求めるなら、John D. Cook による [article](https://www.johndcook.com/blog/2009/04/06/anatomy-of-a-floating-point-number/) を参照してください。また、この表現が理想化された実数の抽象モデルとは異なる振る舞いをすることから生じる問題については、同氏の [introduction](https://www.johndcook.com/blog/2009/04/06/numbers-are-a-leaky-abstraction/) も参考になります。
  * Bruce Dawson の [series of blog posts on floating-point numbers](https://randomascii.wordpress.com/2012/05/20/thats-not-normalthe-performance-of-odd-floats/) もお勧めです。
  * 浮動小数点数と、それを使った計算で生じる数値精度の問題について、優れた詳細な解説を求めるなら、David Goldberg の論文 [What Every Computer Scientist Should Know About Floating-Point Arithmetic](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.22.6768&rep=rep1&type=pdf) を参照してください。
  * 浮動小数点数の歴史、設計の根拠、問題点についてさらに詳しい資料や、数値計算に関するさまざまな話題の解説については、「浮動小数点の父」として知られる [William Kahan](https://en.wikipedia.org/wiki/William_Kahan) の [collected writings](https://people.eecs.berkeley.edu/~wkahan/) を参照してください。特に [An Interview with the Old Man of Floating-Point](https://people.eecs.berkeley.edu/~wkahan/ieee754status/754story.html) は興味深いでしょう。

## Arbitrary Precision Arithmetic

任意精度の整数と浮動小数点数による計算を可能にするため、Julia はそれぞれ [GNU Multiple Precision Arithmetic Library (GMP)](https://gmplib.org) と [GNU MPFR Library](https://www.mpfr.org) をラップしています。Julia では、任意精度の整数には [`BigInt`](@ref) 型を、任意精度の浮動小数点数には [`BigFloat`](@ref) 型を使用できます。

プリミティブ数値型からこれらの型の値を作成するコンストラクタが用意されています。また、[string literal](@ref non-standard-string-literals) [`@big_str`](@ref) または [`parse`](@ref) を使って、`AbstractString` から構築することもできます。`BigInt` の値は、他の組み込み整数型には大きすぎる整数リテラルとして入力することもできます。`Base` には符号なしの任意精度整数型はありませんが（ほとんどの場合は `BigInt` で十分です）、10進リテラルに加えて、16進、8進、2進リテラルも使えます。

作成した値は、Julia の [type promotion and conversion mechanism](@ref conversion-and-promotion) により、他のすべての数値型との算術演算に使用できます。

```jldoctest
julia> BigInt(typemax(Int64)) + 1
9223372036854775808

julia> big"123456789012345678901234567890" + 1
123456789012345678901234567891

julia> parse(BigInt, "123456789012345678901234567890") + 1
123456789012345678901234567891

julia> string(big"2"^200, base=16)
"100000000000000000000000000000000000000000000000000"

julia> 0x100000000000000000000000000000000-1 == typemax(UInt128)
true

julia> 0x000000000000000000000000000000000
0

julia> typeof(ans)
BigInt

julia> big"1.23456789012345678901"
1.234567890123456789010000000000000000000000000000000000000000000000000000000004

julia> parse(BigFloat, "1.23456789012345678901")
1.234567890123456789010000000000000000000000000000000000000000000000000000000004

julia> BigFloat(2.0^66) / 3
2.459565876494606882133333333333333333333333333333333333333333333333333333333344e19

julia> factorial(BigInt(40))
815915283247897734345611269596115894272000000000
```

ただし、上記のプリミティブ型と [`BigInt`](@ref)/[`BigFloat`](@ref) の間の型昇格は自動では行われず、明示的に指定する必要があります。

```jldoctest
julia> x = typemin(Int64)
-9223372036854775808

julia> x = x - 1
9223372036854775807

julia> typeof(x)
Int64

julia> y = BigInt(typemin(Int64))
-9223372036854775808

julia> y = y - 1
-9223372036854775809

julia> typeof(y)
BigInt
```

[`BigFloat`](@ref) の演算におけるデフォルトの精度（仮数部のビット数）と丸めモードは、[`setprecision`](@ref) と [`setrounding`](@ref) を呼び出すことでグローバルに変更できます。それ以降のすべての計算には、変更後の設定が適用されます。また、同じ関数を `do` ブロックとともに使うと、特定のコードブロックの実行中だけ精度や丸めモードを変更できます。

```jldoctest
julia> setrounding(BigFloat, RoundUp) do
           BigFloat(1) + parse(BigFloat, "0.1")
       end
1.100000000000000000000000000000000000000000000000000000000000000000000000000003

julia> setrounding(BigFloat, RoundDown) do
           BigFloat(1) + parse(BigFloat, "0.1")
       end
1.099999999999999999999999999999999999999999999999999999999999999999999999999986

julia> setprecision(40) do
           BigFloat(1) + parse(BigFloat, "0.1")
       end
1.1000000000004
```

!!! warning
    [`setprecision`](@ref) または [`setrounding`](@ref) と、`big` 文字列リテラル（`big"0.3"` など）に使われるマクロ [`@big_str`](@ref) との関係は、直感的でないかもしれません。これは `@big_str` がマクロであることに起因します。詳しくは [`@big_str`](@ref) のドキュメントを参照してください。


## [Numeric Literal Coefficients](@id man-numeric-literal-coefficients)

よく使われる数式や式を読みやすくするため、Julia では変数の直前に数値リテラルを置くことで乗算を表せます。これにより、多項式をすっきりと記述できます。

```jldoctest numeric-coefficients
julia> x = 3
3

julia> 2x^2 - 3x + 1
10

julia> 1.5x^2 - .5x + 1
13.0
```

指数関数も、より簡潔に記述できます。

```jldoctest numeric-coefficients
julia> 2^2x
64
```

数値リテラル係数の優先順位は、符号反転などの単項演算子よりわずかに低くなっています。そのため、`-2x` は `(-2) * x` として、`√2x` は `(√2) * x` として構文解析されます。ただし、べき乗と組み合わせた場合、数値リテラル係数は単項演算子と同様に構文解析されます。たとえば、`2^3x` は `2^(3x)` として、`2x^3` は `2*(x^3)` として構文解析されます。

数値リテラルは、括弧で囲んだ式の係数としても使えます。

```jldoctest numeric-coefficients
julia> 2(x-1)^2 - 3(x-1) + 1
3
```

!!! note
    暗黙の乗算に使われる数値リテラル係数は、乗算（`*`）や除算（`/`、`\`、`//`）などの他の二項演算子より優先順位が高くなっています。そのため、たとえば `1 / 2im` は `-0.5im` と等しく、`6 // 2(2 + 1)` は `1 // 1` と等しくなります。


さらに、括弧で囲んだ式を変数の係数として使うこともでき、その式と変数の乗算を表します。

```jldoctest numeric-coefficients
julia> (x-1)x
6
```

ただし、括弧で囲んだ2つの式を隣接させたり、括弧で囲んだ式の前に変数を置いたりしても、乗算を表すことはできません。

```jldoctest numeric-coefficients
julia> (x-1)(x+1)
ERROR: MethodError: objects of type Int64 are not callable

julia> x(x+1)
ERROR: MethodError: objects of type Int64 are not callable
```

これらの式はどちらも関数適用として解釈されます。数値リテラル以外の式の直後に括弧を置くと、その式を関数として括弧内の値に適用するものと解釈されます（関数について詳しくは [Functions](@ref) を参照してください）。したがって、どちらの場合も左側の値が関数ではないため、エラーが発生します。

これらの構文上の工夫により、一般的な数式を記述する際の視覚的な煩雑さが大幅に軽減されます。ただし、数値リテラル係数と、それを掛ける識別子または括弧で囲んだ式との間に空白を入れることはできません。

### Syntax Conflicts

リテラル係数を隣接させる構文は、一部の数値リテラル構文、すなわち16進・8進・2進整数リテラルや浮動小数点リテラルの工学表記と競合する可能性があります。構文が競合する例を次に示します。

  * 16進整数リテラル式 `0xff` は、数値リテラル `0` と変数 `xff` の乗算とも解釈できます。`0o777` や `0b01001010` のような8進・2進リテラルにも、同様の曖昧さがあります。
  * 浮動小数点リテラル式 `1e10` は、数値リテラル `1` と変数 `e10` の乗算とも解釈できます。同等の `E` という形式でも同様です。
  * 32ビット浮動小数点リテラル式 `1.5f22` は、数値リテラル `1.5` と変数 `f22` の乗算とも解釈できます。

いずれの場合も、数値リテラルとしての解釈を優先することで曖昧さを解消します。

  * `0x`/`0o`/`0b` で始まる式は、常にそれぞれ16進・8進・2進リテラルになります。
  * 数値リテラルの直後に `e` または `E` が続く形で始まる式は、常に浮動小数点リテラルになります。
  * 数値リテラルの直後に `f` が続く形で始まる式は、常に32ビット浮動小数点リテラルになります。

`E` は歴史的な理由から数値リテラル内で `e` と同等に扱われますが、`F` は通常の文字にすぎず、数値リテラル内で `f` のようには動作しません。したがって、数値リテラルの直後に `F` が続く形で始まる式は、数値リテラルと変数の乗算として解釈されます。たとえば、`1.5F22` は `1.5 * F22` と等しくなります。

## Literal zero and one

Julia は、指定した型、または与えられた変数の型に対応するリテラル 0 と 1 を返す関数を提供しています。

| 関数                | 説明                        |
|:----------------- |:------------------------- |
| [`zero(x)`](@ref) | `x` 型、または変数 `x` の型のリテラルゼロ |
| [`one(x)`](@ref)  | `x` 型、または変数 `x` の型のリテラル1  |

これらの関数は、[Numeric Comparisons](@ref) において、不要な [type conversion](@ref conversion-and-promotion) によるオーバーヘッドを避けるのに役立ちます。

例：

```jldoctest
julia> zero(Float32)
0.0f0

julia> zero(1.0)
0.0

julia> one(Int32)
1

julia> one(BigFloat)
1.0
```
