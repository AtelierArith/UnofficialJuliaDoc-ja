# Integers and Floating-Point Numbers

整数と浮動小数点数は、算術演算や計算の基本要素です。こうした値の組み込み表現を数値プリミティブと呼び、コード中で整数や浮動小数点数を即値として表す記法を数値リテラルと呼びます。たとえば、`1` は整数リテラル、`1.0` は浮動小数点リテラルです。これらをオブジェクトとしてメモリ上に保持するときのバイナリ表現が、数値プリミティブです。

Julia には幅広い種類の数値プリミティブが用意されており、それらに対する算術演算子やビット演算子一式、標準的な数学関数も定義されています。これらは、現代のコンピューターがネイティブにサポートする数値型や演算に直接対応しているため、Julia は計算資源を最大限に活用できます。また、Julia は [Arbitrary Precision Arithmetic](@ref) もソフトウェアでサポートしています。これは、ネイティブなハードウェア表現では効率よく表せない数値の演算を扱えますが、その代わりに実行速度は比較的遅くなります。

Julia の数値プリミティブ型は次のとおりです。

  * **整数型:**

| 型                 | 符号付き? | ビット数 | 最小値         | 最大値        |
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

  * **浮動小数点型:**

| 型                 | 精度                                                                             | ビット数 |
|:----------------- |:------------------------------------------------------------------------------ |:---- |
| [`Float16`](@ref) | [half](https://en.wikipedia.org/wiki/Half-precision_floating-point_format)     | 16   |
| [`Float32`](@ref) | [single](https://en.wikipedia.org/wiki/Single_precision_floating-point_format) | 32   |
| [`Float64`](@ref) | [double](https://en.wikipedia.org/wiki/Double_precision_floating-point_format) | 64   |

さらに、これらの数値プリミティブ型を基盤として、[Complex and Rational Numbers](@ref) が完全にサポートされています。柔軟でユーザーが拡張できる [type promotion system](@ref conversion-and-promotion) により、明示的な型変換をしなくても、すべての数値型を自然に相互運用できます。

## Integers

整数リテラルは、標準的な形式で表します。

```jldoctest
julia> 1
1

julia> 1234
1234
```

整数リテラルの既定の型は、対象システムが32ビットアーキテクチャか64ビットアーキテクチャかによって異なります。

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

Julia では、システムの符号付きおよび符号なしネイティブ整数型の別名として、`Int` と `UInt` も定義されています。

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

32ビットでは表せないものの64ビットなら表せる大きな整数リテラルは、システムの型にかかわらず、常に64ビット整数になります。

```jldoctest
# 32-bit or 64-bit system:
julia> typeof(3000000000)
Int64
```

符号なし整数は、`0x` の接頭辞と16進数（基数16）の数字 `0-9a-f` を使って入出力します（大文字の数字 `A-F` も入力に使えます）。符号なし値のサイズは、使用した16進数字の桁数で決まります。

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

この動作は、整数値に符号なし16進リテラルを使う場合、単なる整数値ではなく、固定長の数値バイト列を表すのが一般的であるという考えに基づいています。

2進数および8進数のリテラルも使えます。

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

16進リテラルと同様に、2進数および8進数のリテラルも符号なし整数型になります。リテラルの先頭の数字が `0` でなければ、データ項目のサイズは値を表すのに必要な最小サイズになります。先頭にゼロがある場合は、同じ桁数で先頭の数字が `1` であるリテラルを表すのに必要な最小サイズで決まります。つまり、次のようになります。

  * `0x1` と `0x12` は `UInt8` リテラルです。
  * `0x123` と `0x1234` は `UInt16` リテラルです。
  * `0x12345` と `0x12345678` は `UInt32` リテラルです。
  * `0x123456789` と `0x1234567890adcdef` は `UInt64` リテラルです。以下同様です。

値に影響しない先頭のゼロも、リテラルの格納サイズを決める際には桁数に含まれます。そのため、`0x01` は `UInt8` ですが、`0x0001` は `UInt16` です。

これにより、ユーザーはサイズを指定できます。

`0x` で始まる符号なしリテラルが、`UInt128` 値として表せないほど大きな整数を表す場合は、代わりに `BigInt` 値が生成されます。これは符号なし型ではありませんが、そのような大きな整数値を表せる唯一の組み込み型です。

2進数、8進数、16進数のリテラルは、符号なしリテラルの直前に `-` を置くことで符号付きにできます。符号なしリテラルと同じサイズの符号なし整数が生成され、その値は2の補数になります。

```jldoctest
julia> -0x2
0xfe

julia> -0x0002
0xfffe
```

整数などの数値プリミティブ型で表せる最小値と最大値は、[`typemin`](@ref) 関数と [`typemax`](@ref) 関数で取得できます。

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

[`typemin`](@ref) と [`typemax`](@ref) が返す値は、常に指定した引数の型になります。（上の式には、まだ説明していない [for loops](@ref man-loops)、[Strings](@ref man-strings)、[Interpolation](@ref string-interpolation) などの機能がいくつか使われていますが、プログラミング経験が多少あれば十分理解できるでしょう。）

### Overflow behavior

Julia では、ある型で表せる最大値を超えると、値が折り返す動作が起こります。

```jldoctest
julia> x = typemax(Int64)
9223372036854775807

julia> x + 1
-9223372036854775808

julia> x + 1 == typemin(Int64)
true
```

Julia の整数型による算術演算では、整数オーバーフローが本質的に [modular arithmetic](https://en.wikipedia.org/wiki/Modular_arithmetic) で処理されます。これは現代のコンピューターハードウェアにおける整数演算の特性を反映したものです。オーバーフローの可能性がある場合は、オーバーフローによって生じる折り返しを明示的に確認することが重要です。[`Base.Checked`](@ref) モジュールには、オーバーフローを検出するとエラーを発生させる算術演算が用意されています。どのような場合でもオーバーフローを許容できない用途では、[`BigInt`](@ref) 型を使うことをお勧めします。詳しくは [Arbitrary Precision Arithmetic](@ref) を参照してください。

オーバーフローの動作と、その対処方法の例を次に示します。

```jldoctest
julia> 10^19
-8446744073709551616

julia> big(10)^19
10000000000000000000
```

### Division errors

整数除算（`div` 関数）には、例外的なケースが2つあります。ゼロ除算と、最小の負の数（[`typemin`](@ref)）を -1 で割る場合です。どちらの場合も [`DivideError`](@ref) がスローされます。剰余関数とモジュロ関数（`rem` と `mod`）は、第2引数がゼロの場合に [`DivideError`](@ref) をスローします。

## Floating-Point Numbers

浮動小数点リテラルは、必要に応じて [E-notation](https://en.wikipedia.org/wiki/Scientific_notation#E_notation) を使い、標準的な形式で表します。

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

上記の結果はすべて [`Float64`](@ref) 値です。リテラルの [`Float32`](@ref) 値は、`e` の代わりに `f` を書くことで入力できます。

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

16進浮動小数点リテラルも有効ですが、[`Float64`](@ref) 値としてのみ使えます。基数2の指数の前には `p` を置きます。

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

半精度浮動小数点数（[`Float16`](@ref)）は、すべてのプラットフォームでサポートされています。この数値形式に対応するハードウェアではネイティブ命令が使われます。対応していない場合、演算はソフトウェアで実装され、中間計算には [`Float32`](@ref) が使われます。内部実装の詳細として、これは LLVM の [`half`](https://llvm.org/docs/LangRef.html#half-precision-floating-point-intrinsics) 型を使って実現されています。この型は、C/C++ コードで GCC の [`-fexcess-precision=16`](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html#index-fexcess-precision) フラグを指定した場合と同様に動作します。

```jldoctest
julia> sizeof(Float16(4.))
2

julia> 2*Float16(4.)
Float16(8.0)
```

数字の区切りには、アンダースコア `_` を使えます。

```jldoctest
julia> 10_000, 0.000_000_005, 0xdead_beef, 0b1011_0010
(10000, 5.0e-9, 0xdeadbeef, 0xb2)
```

### Floating-point zero

浮動小数点数には [two zeros](https://en.wikipedia.org/wiki/Signed_zero) があり、正のゼロと負のゼロも区別されます。両者は等しい値ですが、バイナリ表現は異なります。これは [`bitstring`](@ref) 関数で確認できます。

```jldoctest
julia> 0.0 == -0.0
true

julia> bitstring(0.0)
"0000000000000000000000000000000000000000000000000000000000000000"

julia> bitstring(-0.0)
"1000000000000000000000000000000000000000000000000000000000000000"
```

### Special floating-point values

実数直線上のどの点にも対応しない、標準で定められた浮動小数点値が3つあります。

| `Float16` | `Float32` | `Float64` | 名前    | 説明                         |
|:--------- |:--------- |:--------- |:----- |:-------------------------- |
| `Inf16`   | `Inf32`   | `Inf`     | 正の無限大 | すべての有限な浮動小数点値より大きい値        |
| `-Inf16`  | `-Inf32`  | `-Inf`    | 負の無限大 | すべての有限な浮動小数点値より小さい値        |
| `NaN16`   | `NaN32`   | `NaN`     | 数ではない | `==` ではない浮動小数点値（自身との比較も含む） |

これらの非有限浮動小数点値と、ほかの浮動小数点値との順序関係については、[Numeric Comparisons](@ref) を参照してください。[IEEE 754 standard](https://en.wikipedia.org/wiki/IEEE_754-2008) に従い、これらの浮動小数点値は特定の算術演算の結果として得られます。

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

ほとんどの実数は浮動小数点数で正確に表せません。そのため、多くの用途では、隣り合う2つの表現可能な浮動小数点数の間隔を知ることが重要です。この間隔は、しばしば [machine epsilon](https://en.wikipedia.org/wiki/Machine_epsilon) と呼ばれます。

Julia の [`eps`](@ref) は、`1.0` と、それより大きい次の表現可能な浮動小数点値との間隔を返します。

```jldoctest
julia> eps(Float32)
1.1920929f-7

julia> eps(Float64)
2.220446049250313e-16

julia> eps() # same as eps(Float64)
2.220446049250313e-16
```

これらの値は、それぞれ [`Float32`](@ref) 値と [`Float64`](@ref) 値として、`2.0^-23` と `2.0^-52` です。[`eps`](@ref) 関数には浮動小数点値を引数として渡すこともでき、その値と次に表現可能な浮動小数点値との差の絶対値を返します。つまり、`eps(x)` は `x` と同じ型の値を返し、`x + eps(x)` は `x` より大きい、次の表現可能な浮動小数点値になります。

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

隣り合う表現可能な浮動小数点数の間隔は一定ではありません。値が小さいほど間隔は狭く、値が大きいほど広くなります。つまり、実数直線上ではゼロの近くに表現可能な浮動小数点数が最も密集し、ゼロから離れるにつれて指数関数的にまばらになります。定義上、`eps(1.0)` は `eps(Float64)` と同じです。`1.0` は64ビット浮動小数点値だからです。

Julia には、引数の次に大きい、または次に小さい表現可能な浮動小数点数を返す [`nextfloat`](@ref) 関数と [`prevfloat`](@ref) 関数もあります。

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

この例は、隣り合う表現可能な浮動小数点数のバイナリ整数表現も隣り合っている、という一般原則を示しています。

### Rounding modes

数値を浮動小数点数で正確に表せない場合は、適切な表現可能値に丸める必要があります。ただし、必要に応じて [IEEE 754 standard](https://en.wikipedia.org/wiki/IEEE_754-2008) で説明する丸めモードを使い、丸め方を変更できます。

既定のモードは常に [`RoundNearest`](@ref) です。最も近い表現可能値に丸め、ちょうど中間の場合は、最下位ビットが偶数となるほうの値に丸めます。

### Background and References

浮動小数点演算には、低レベルの実装の詳細に詳しくないユーザーには意外に感じられる、多くの微妙な点があります。しかし、こうした点は科学計算に関する多くの書籍で詳しく説明されているほか、次の資料も参考になります。

  * 浮動小数点演算についての決定版は [IEEE 754-2008 Standard](https://standards.ieee.org/standard/754-2008.html) ですが、オンラインでは無料で入手できません。
  * 浮動小数点数の表現方法を簡潔かつ明快に知るには、John D. Cook による [article](https://www.johndcook.com/blog/2009/04/06/anatomy-of-a-floating-point-number/) と、実数の理想化された抽象表現とは異なる動作が生じることで起こる問題を扱った [introduction](https://www.johndcook.com/blog/2009/04/06/numbers-are-a-leaky-abstraction/) を参照してください。
  * Bruce Dawson の [series of blog posts on floating-point numbers](https://randomascii.wordpress.com/2012/05/20/thats-not-normalthe-performance-of-odd-floats/) もお勧めです。
  * 浮動小数点数と、それを使った計算で生じる数値精度の問題について、優れた詳細な解説を読みたい場合は、David Goldberg の論文 [What Every Computer Scientist Should Know About Floating-Point Arithmetic](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.22.6768&rep=rep1&type=pdf) を参照してください。
  * 浮動小数点数の歴史や根拠、問題点に加え、数値計算に関するさまざまな話題をさらに詳しく知るには、「浮動小数点の父」として知られる [William Kahan](https://en.wikipedia.org/wiki/William_Kahan) の [collected writings](https://people.eecs.berkeley.edu/~wkahan/) を参照してください。特に [An Interview with the Old Man of Floating-Point](https://people.eecs.berkeley.edu/~wkahan/ieee754status/754story.html) が参考になるでしょう。

## Arbitrary Precision Arithmetic

任意精度の整数や浮動小数点数を使った計算を可能にするため、Julia はそれぞれ [GNU Multiple Precision Arithmetic Library (GMP)](https://gmplib.org) と [GNU MPFR Library](https://www.mpfr.org) をラップしています。任意精度の整数と浮動小数点数には、それぞれ [`BigInt`](@ref) 型と [`BigFloat`](@ref) 型を使います。

数値プリミティブ型からこれらの型を作成するコンストラクターが用意されています。また、[string literal](@ref non-standard-string-literals) [`@big_str`](@ref) または [`parse`](@ref) を使って、`AbstractString` から作成することもできます。ほかの組み込み整数型では大きすぎる場合、`BigInt` は整数リテラルとして入力することもできます。`Base` には任意精度の符号なし整数型がありません（ほとんどの場合は `BigInt` で十分です）が、16進数、8進数、2進数のリテラルも（10進数リテラルに加えて）使用できます。

作成後は、Julia の [type promotion and conversion mechanism](@ref conversion-and-promotion) により、ほかのすべての数値型との算術演算に使えます。

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

ただし、上記の数値プリミティブ型と [`BigInt`](@ref) / [`BigFloat`](@ref) の間では、型昇格は自動的に行われないため、明示的に指定する必要があります。

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

[`BigFloat`](@ref) 演算の既定の精度（仮数部のビット数）と丸めモードは、[`setprecision`](@ref) と [`setrounding`](@ref) を呼び出すことでグローバルに変更できます。以降の計算には、変更後の設定が適用されます。また、同じ関数に `do` ブロックを渡せば、特定のコードブロックの実行中だけ精度や丸めモードを変更できます。

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
    [`setprecision`](@ref) または [`setrounding`](@ref) と、`big"0.3"` のような `big` 文字列リテラルに使われるマクロ [`@big_str`](@ref) との関係は、`@big_str` がマクロであるため、直感的でない場合があります。詳しくは [`@big_str`](@ref) のドキュメントを参照してください。


## [Numeric Literal Coefficients](@id man-numeric-literal-coefficients)

一般的な数式や式を読みやすくするため、Julia では数値リテラルの直後に変数を置くと、乗算を表すことができます。これにより、多項式をすっきりと記述できます。

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

数値リテラル係数の優先順位は、否定などの単項演算子よりわずかに低くなります。そのため、`-2x` は `(-2) * x` として解析され、`√2x` は `(√2) * x` として解析されます。ただし、べき乗と組み合わせた場合、数値リテラル係数は単項演算子と同様に解析されます。たとえば、`2^3x` は `2^(3x)` として、`2x^3` は `2*(x^3)` として解析されます。

数値リテラルは、括弧で囲んだ式の係数としても使えます。

```jldoctest numeric-coefficients
julia> 2(x-1)^2 - 3(x-1) + 1
3
```

!!! note
    暗黙の乗算に使う数値リテラル係数の優先順位は、乗算（`*`）や除算（`/`、`\`、`//`）など、ほかの二項演算子より高くなります。たとえば、`1 / 2im` は `-0.5im` と等しく、`6 // 2(2 + 1)` は `1 // 1` と等しくなります。


括弧で囲んだ式を変数の係数として使うこともできます。この場合、式と変数の乗算を表します。

```jldoctest numeric-coefficients
julia> (x-1)x
6
```

ただし、括弧で囲んだ式を2つ並べたり、変数の後に括弧で囲んだ式を置いたりしても、乗算を表すことはできません。

```jldoctest numeric-coefficients
julia> (x-1)(x+1)
ERROR: MethodError: objects of type Int64 are not callable

julia> x(x+1)
ERROR: MethodError: objects of type Int64 are not callable
```

どちらの式も関数呼び出しとして解釈されます。括弧の直前にある式が数値リテラルでない場合、その式は括弧内の値を引数として受け取る関数として解釈されます（関数について詳しくは [Functions](@ref) を参照してください）。この2つのケースでは、左辺の値が関数ではないため、どちらもエラーになります。

このような構文上の拡張により、一般的な数式を記述する際の視覚的な煩雑さを大幅に減らせます。数値リテラル係数と、それが乗算する識別子または括弧で囲んだ式との間に空白を入れることはできません。

### Syntax Conflicts

リテラル係数を並べる構文は、数値リテラルの一部の構文、すなわち16進数、8進数、2進数の整数リテラルや、浮動小数点リテラルの工学表記と競合することがあります。構文上の競合が起こる例を次に示します。

  * 16進整数リテラルの式 `0xff` は、数値リテラル `0` と変数 `xff` の積とも解釈できます。`0o777` や `0b01001010` のような8進数や2進数のリテラルでも、同様の曖昧さが生じます。
  * 浮動小数点リテラルの式 `1e10` は、数値リテラル `1` と変数 `e10` の積とも解釈できます。同等の `E` 形式でも同様です。
  * 32ビット浮動小数点リテラルの式 `1.5f22` は、数値リテラル `1.5` と変数 `f22` の積とも解釈できます。

いずれの場合も、曖昧さは数値リテラルとして解釈することで解消されます。

  * `0x` / `0o` / `0b` で始まる式は、常に16進数、8進数、2進数のリテラルです。
  * 数値リテラルの後に `e` または `E` が続く式は、常に浮動小数点リテラルです。
  * 数値リテラルの後に `f` が続く式は、常に32ビット浮動小数点リテラルです。

歴史的な理由から、数値リテラルでは `E` は `e` と同等ですが、`F` は単なる別の文字であり、数値リテラル内で `f` のようには動作しません。そのため、数値リテラルの後に `F` が続く式は、数値リテラルと変数の積として解釈されます。たとえば、`1.5F22` は `1.5 * F22` と等しくなります。

## Literal zero and one

Julia には、指定した型または変数の型に対応するリテラルの 0 と 1 を返す関数があります。

| 関数                | 説明                         |
|:----------------- |:-------------------------- |
| [`zero(x)`](@ref) | `x` 型、または変数 `x` の型のリテラルのゼロ |
| [`one(x)`](@ref)  | `x` 型、または変数 `x` の型のリテラルの1  |

これらの関数は、[Numeric Comparisons](@ref) で不要な [type conversion](@ref conversion-and-promotion) によるオーバーヘッドを避けるのに役立ちます。

例:

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
