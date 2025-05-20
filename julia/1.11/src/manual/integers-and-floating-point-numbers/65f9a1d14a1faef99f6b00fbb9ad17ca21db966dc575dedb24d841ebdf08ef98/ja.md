# Integers and Floating-Point Numbers

整数と浮動小数点値は、算術と計算の基本的な構成要素です。このような値の組み込み表現は数値プリミティブと呼ばれ、コード内での整数および浮動小数点数の即値としての表現は数値リテラルとして知られています。たとえば、`1`は整数リテラルであり、`1.0`は浮動小数点リテラルです。これらのオブジェクトとしてのバイナリのメモリ内表現は数値プリミティブです。

Juliaは幅広い原始的な数値型を提供しており、算術演算子やビット演算子、標準的な数学関数がそれらに対して定義されています。これらは、現代のコンピュータでネイティブにサポートされている数値型や演算に直接マッピングされるため、Juliaは計算リソースを最大限に活用することができます。さらに、Juliaは[Arbitrary Precision Arithmetic](@ref)のソフトウェアサポートを提供しており、ネイティブハードウェア表現では効果的に表現できない数値に対する演算を処理できますが、その分相対的にパフォーマンスが遅くなります。

以下はJuliaの基本的な数値型です：

  * **整数型:**

| Type              | Signed? | Number of bits | Smallest value | Largest value |
|:----------------- |:------- |:-------------- |:-------------- |:------------- |
| [`Int8`](@ref)    | ✓       | 8              | -2^7           | 2^7 - 1       |
| [`UInt8`](@ref)   |         | 8              | 0              | 2^8 - 1       |
| [`Int16`](@ref)   | ✓       | 16             | -2^15          | 2^15 - 1      |
| [`UInt16`](@ref)  |         | 16             | 0              | 2^16 - 1      |
| [`Int32`](@ref)   | ✓       | 32             | -2^31          | 2^31 - 1      |
| [`UInt32`](@ref)  |         | 32             | 0              | 2^32 - 1      |
| [`Int64`](@ref)   | ✓       | 64             | -2^63          | 2^63 - 1      |
| [`UInt64`](@ref)  |         | 64             | 0              | 2^64 - 1      |
| [`Int128`](@ref)  | ✓       | 128            | -2^127         | 2^127 - 1     |
| [`UInt128`](@ref) |         | 128            | 0              | 2^128 - 1     |
| [`Bool`](@ref)    | N/A     | 8              | `false` (0)    | `true` (1)    |

  * **浮動小数点型:**

| Type              | Precision                                                                      | Number of bits |
|:----------------- |:------------------------------------------------------------------------------ |:-------------- |
| [`Float16`](@ref) | [half](https://en.wikipedia.org/wiki/Half-precision_floating-point_format)     | 16             |
| [`Float32`](@ref) | [single](https://en.wikipedia.org/wiki/Single_precision_floating-point_format) | 32             |
| [`Float64`](@ref) | [double](https://en.wikipedia.org/wiki/Double_precision_floating-point_format) | 64             |

さらに、[Complex and Rational Numbers](@ref) の完全なサポートは、これらの基本的な数値型の上に構築されています。すべての数値型は、明示的なキャストなしで自然に相互運用でき、柔軟でユーザー拡張可能な [type promotion system](@ref conversion-and-promotion) のおかげです。

## Integers

リテラル整数は標準的な方法で表現されます：

```jldoctest
julia> 1
1

julia> 1234
1234
```

整数リテラルのデフォルトタイプは、ターゲットシステムが32ビットアーキテクチャか64ビットアーキテクチャかによって異なります：

```julia-repl
# 32-bit system:
julia> typeof(1)
Int32

# 64-bit system:
julia> typeof(1)
Int64
```

Juliaの内部変数 [`Sys.WORD_SIZE`](@ref) は、ターゲットシステムが32ビットか64ビットかを示します：

```julia-repl
# 32-bit system:
julia> Sys.WORD_SIZE
32

# 64-bit system:
julia> Sys.WORD_SIZE
64
```

Juliaはまた、システムの符号付きおよび符号なしのネイティブ整数型のエイリアスである`Int`と`UInt`の型を定義しています。

```julia-repl
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

32ビットでは表現できないが64ビットでは表現できる大きな整数リテラルは、システムのタイプに関係なく常に64ビット整数を生成します。

```jldoctest
# 32-bit or 64-bit system:
julia> typeof(3000000000)
Int64
```

符号なし整数は、`0x` プレフィックスと16進数（基数16）数字 `0-9a-f` を使用して入力および出力されます（大文字の数字 `A-F` も入力に使用できます）。符号なし値のサイズは、使用される16進数の桁数によって決まります：

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

この動作は、整数値に対して符号なしの16進数リテラルを使用する際、通常は単なる整数値ではなく、固定された数値のバイトシーケンスを表すために使用されるという観察に基づいています。

バイナリおよび8進数リテラルもサポートされています：

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

16進数リテラルに関して、2進数および8進数リテラルは符号なし整数型を生成します。バイナリデータ項目のサイズは、リテラルの先頭の桁が `0` でない場合、必要な最小サイズです。先頭にゼロがある場合、サイズは、同じ長さで先頭の桁が `1` のリテラルに対して必要な最小サイズによって決まります。つまり、次のことを意味します：

  * `0x1` と `0x12` は `UInt8` リテラルです、
  * `0x123` と `0x1234` は `UInt16` リテラルです、
  * `0x12345` と `0x12345678` は `UInt32` リテラルです、
  * `0x123456789` と `0x1234567890adcdef` は `UInt64` リテラルです。

先頭のゼロが値に寄与しない場合でも、それはリテラルのストレージサイズを決定するためにカウントされます。したがって、`0x01`は`UInt8`であり、`0x0001`は`UInt16`です。

それにより、ユーザーはサイズを制御できます。

`UInt128` 値として表現できないほど大きな整数をエンコードする `0x` で始まる符号なしリテラルは、代わりに `BigInt` 値を構築します。これは符号なし型ではありませんが、そのような大きな整数値を表現するのに十分な唯一の組み込み型です。

バイナリ、8進数、および16進数リテラルは、符号なしリテラルの直前に`-`を付けることで符号を持つことができます。これにより、符号なしリテラルと同じサイズの符号なし整数が生成され、その値の2の補数が得られます。

```jldoctest
julia> -0x2
0xfe

julia> -0x0002
0xfffe
```

プリミティブ数値型（整数など）の最小および最大の表現可能値は、[`typemin`](@ref) および [`typemax`](@ref) 関数によって示されます：

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

[`typemin`](@ref) と [`typemax`](@ref) によって返される値は、常に指定された引数の型になります。（上記の式は、まだ導入されていないいくつかの機能を使用していますが、[for loops](@ref man-loops)、[Strings](@ref man-strings)、および [Interpolation](@ref string-interpolation) を含んでいますが、いくつかのプログラミング経験があるユーザーには理解しやすいはずです。）

### Overflow behavior

Juliaでは、特定の型の最大表現可能値を超えると、ラップアラウンドの動作が発生します：

```jldoctest
julia> x = typemax(Int64)
9223372036854775807

julia> x + 1
-9223372036854775808

julia> x + 1 == typemin(Int64)
true
```

ジュリアの整数型による算術演算は、現代のコンピュータハードウェアにおける整数演算の特性を反映して、[modular arithmetic](https://en.wikipedia.org/wiki/Modular_arithmetic)を自動的に実行します。オーバーフローの可能性があるシナリオでは、そのようなオーバーフローから生じるラップアラウンド効果を明示的にチェックすることが重要です。[`Base.Checked`](@ref)モジュールは、オーバーフローが発生した場合にエラーをトリガーするオーバーフローチェック付きの算術演算のスイートを提供します。オーバーフローがいかなる状況でも許容できない使用ケースでは、[`BigInt`](@ref)型を利用することが推奨されます。これは、[Arbitrary Precision Arithmetic](@ref)で詳述されています。

オーバーフローの動作の例と、それを解決する可能性のある方法は次のとおりです：

```jldoctest
julia> 10^19
-8446744073709551616

julia> big(10)^19
10000000000000000000
```

### Division errors

整数除算（`div`関数）には、ゼロで割る場合と、最小の負の数（[`typemin`](@ref)）を-1で割る場合の2つの例外的なケースがあります。これらのケースはどちらも[`DivideError`](@ref)をスローします。余りおよび剰余関数（`rem`および`mod`）は、第二引数がゼロのときに`4d61726b646f776e2e436f64652822222c20224469766964654572726f722229_40726566`をスローします。

## Floating-Point Numbers

リテラル浮動小数点数は、標準フォーマットで表現され、必要に応じて [E-notation](https://en.wikipedia.org/wiki/Scientific_notation#E_notation) を使用します:

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

上記の結果はすべて [`Float64`](@ref) 値です。リテラル [`Float32`](@ref) 値は、`e` の代わりに `f` を書くことで入力できます：

```jldoctest
julia> x = 0.5f0
0.5f0

julia> typeof(x)
Float32

julia> 2.5f-4
0.00025f0
```

値は簡単に [`Float32`](@ref) に変換できます:

```jldoctest
julia> x = Float32(-1.5)
-1.5f0

julia> typeof(x)
Float32
```

16進浮動小数点リテラルも有効ですが、[`Float64`](@ref) 値としてのみ有効で、`p` が2進数の指数の前に置かれます：

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

半精度浮動小数点数はすべてのプラットフォームでサポートされています（[`Float16`](@ref)）。この数値形式をサポートするハードウェアではネイティブ命令が使用されます。それ以外の場合、演算はソフトウェアで実装され、[`Float32`](@ref) が中間計算に使用されます。内部実装の詳細として、これはLLVMの[`half`](https://llvm.org/docs/LangRef.html#half-precision-floating-point-intrinsics)型を使用することで実現されており、これはGCCの[`-fexcess-precision=16`](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html#index-fexcess-precision)フラグがC/C++コードに対して行うのと同様に動作します。

```jldoctest
julia> sizeof(Float16(4.))
2

julia> 2*Float16(4.)
Float16(8.0)
```

アンダースコア `_` は数字の区切り文字として使用できます：

```jldoctest
julia> 10_000, 0.000_000_005, 0xdead_beef, 0b1011_0010
(10000, 5.0e-9, 0xdeadbeef, 0xb2)
```

### Floating-point zero

浮動小数点数には [two zeros](https://en.wikipedia.org/wiki/Signed_zero) があり、正のゼロと負のゼロがあります。これらは互いに等しいですが、異なるバイナリ表現を持っています。これは [`bitstring`](@ref) 関数を使用することで確認できます。

```jldoctest
julia> 0.0 == -0.0
true

julia> bitstring(0.0)
"0000000000000000000000000000000000000000000000000000000000000000"

julia> bitstring(-0.0)
"1000000000000000000000000000000000000000000000000000000000000000"
```

### Special floating-point values

実数直線上の任意の点に対応しない3つの指定された標準浮動小数点値があります：

| `Float16` | `Float32` | `Float64` | Name              | Description                                                     |
|:--------- |:--------- |:--------- |:----------------- |:--------------------------------------------------------------- |
| `Inf16`   | `Inf32`   | `Inf`     | positive infinity | a value greater than all finite floating-point values           |
| `-Inf16`  | `-Inf32`  | `-Inf`    | negative infinity | a value less than all finite floating-point values              |
| `NaN16`   | `NaN32`   | `NaN`     | not a number      | a value not `==` to any floating-point value (including itself) |

さらなる議論については、これらの非有限浮動小数点値が互いにおよび他の浮動小数点数に対してどのように順序付けられているかを参照してください [Numeric Comparisons](@ref)。 [IEEE 754 standard](https://en.wikipedia.org/wiki/IEEE_754-2008) によれば、これらの浮動小数点値は特定の算術演算の結果です：

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

[`typemin`](@ref) および [`typemax`](@ref) 関数は、浮動小数点型にも適用されます：

```jldoctest
julia> (typemin(Float16),typemax(Float16))
(-Inf16, Inf16)

julia> (typemin(Float32),typemax(Float32))
(-Inf32, Inf32)

julia> (typemin(Float64),typemax(Float64))
(-Inf, Inf)
```

### Machine epsilon

ほとんどの実数は浮動小数点数で正確に表現することができないため、多くの目的において、隣接する表現可能な浮動小数点数の間の距離を知ることが重要です。これはしばしば [machine epsilon](https://en.wikipedia.org/wiki/Machine_epsilon) として知られています。

Juliaは[`eps`](@ref)を提供し、`1.0`と次に大きい表現可能な浮動小数点値との距離を示します：

```jldoctest
julia> eps(Float32)
1.1920929f-7

julia> eps(Float64)
2.220446049250313e-16

julia> eps() # same as eps(Float64)
2.220446049250313e-16
```

これらの値は `2.0^-23` と `2.0^-52` であり、それぞれ [`Float32`](@ref) と [`Float64`](@ref) です。 [`eps`](@ref) 関数は浮動小数点値を引数として受け取ることもでき、その値と次に表現可能な浮動小数点値との絶対差を返します。つまり、`eps(x)` は `x` と同じ型の値を返し、`x + eps(x)` は `x` より大きい次の表現可能な浮動小数点値になります。

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

隣接する表現可能な浮動小数点数の間の距離は一定ではなく、小さい値では小さく、大きい値では大きくなります。言い換えれば、表現可能な浮動小数点数は実数直線のゼロ付近で最も密集しており、ゼロから遠ざかるにつれて指数関数的にまばらになります。定義により、`eps(1.0)`は`eps(Float64)`と同じであり、`1.0`は64ビットの浮動小数点値です。

Juliaは、引数に対してそれぞれ次に大きいまたは小さい表現可能な浮動小数点数を返す[`nextfloat`](@ref)および[`prevfloat`](@ref)関数も提供しています。

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

この例は、隣接する表現可能な浮動小数点数が隣接する2進整数表現も持つという一般的な原則を強調しています。

### Rounding modes

数値が正確な浮動小数点表現を持たない場合、適切な表現可能な値に丸める必要があります。ただし、この丸め方は、[IEEE 754 standard](https://en.wikipedia.org/wiki/IEEE_754-2008)に示されている丸めモードに従って変更することができます。

デフォルトモードは常に [`RoundNearest`](@ref) が使用され、最も近い表現可能な値に丸められ、結びつきがある場合は最も近い偶数の最下位ビットを持つ値に丸められます。

### Background and References

浮動小数点演算には、多くの微妙な点があり、低レベルの実装の詳細に不慣れなユーザーには驚くべきことがあります。しかし、これらの微妙な点は、ほとんどの科学計算に関する書籍や、以下の参考文献で詳細に説明されています。

  * 浮動小数点算術に関する決定版ガイドは [IEEE 754-2008 Standard](https://standards.ieee.org/standard/754-2008.html) ですが、オンラインで無料では入手できません。
  * 浮動小数点数がどのように表現されるかについての簡潔で明瞭なプレゼンテーションについては、John D. Cookの [article](https://www.johndcook.com/blog/2009/04/06/anatomy-of-a-floating-point-number/) を参照してください。また、彼の [introduction](https://www.johndcook.com/blog/2009/04/06/numbers-are-a-leaky-abstraction/) も、浮動小数点数の表現が実数の理想化された抽象とどのように異なるかから生じるいくつかの問題についての情報を提供しています。
  * また、ブルース・ドーソンの [series of blog posts on floating-point numbers](https://randomascii.wordpress.com/2012/05/20/thats-not-normalthe-performance-of-odd-floats/) も推奨されています。
  * 浮動小数点数とそれを用いた計算で遭遇する数値精度の問題についての優れた詳細な議論については、デビッド・ゴールドバーグの論文 [What Every Computer Scientist Should Know About Floating-Point Arithmetic](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.22.6768&rep=rep1&type=pdf) を参照してください。
  * さらに詳細な浮動小数点数の歴史、理由、問題、および数値計算に関する多くの他のトピックについての文書は、[collected writings](https://people.eecs.berkeley.edu/~wkahan/)を参照してください。これは[William Kahan](https://en.wikipedia.org/wiki/William_Kahan)として一般的に知られており、「浮動小数点の父」と呼ばれています。特に興味深いのは、[An Interview with the Old Man of Floating-Point](https://people.eecs.berkeley.edu/~wkahan/ieee754status/754story.html)です。

## Arbitrary Precision Arithmetic

任意精度の整数および浮動小数点数での計算を可能にするために、Juliaは [GNU Multiple Precision Arithmetic Library (GMP)](https://gmplib.org) と [GNU MPFR Library](https://www.mpfr.org) をそれぞれラップしています。 [`BigInt`](@ref) と [`BigFloat`](@ref) タイプは、Juliaでそれぞれ任意精度の整数および浮動小数点数に利用可能です。

コンストラクタは、原始的な数値型からこれらの型を作成するために存在します。[string literal](@ref non-standard-string-literals)、[`@big_str`](@ref)、または[`parse`](@ref)を使用して、`AbstractString`からそれらを構築することができます。`BigInt`は、他の組み込み整数型では大きすぎる場合に整数リテラルとしても入力できます。`Base`には符号なしの任意精度整数型がないため（`BigInt`はほとんどの場合に十分です）、16進数、8進数、2進数のリテラルを使用することができます（10進数リテラルに加えて）。

一度作成されると、Juliaの [type promotion and conversion mechanism](@ref conversion-and-promotion) によって、すべての他の数値型との算術演算に参加します。

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
2.459565876494606882133333333333333333333333333333333333333333333333333333333344e+19

julia> factorial(BigInt(40))
815915283247897734345611269596115894272000000000
```

However, type promotion between the primitive types above and [`BigInt`](@ref)/[`BigFloat`](@ref) is not automatic and must be explicitly stated.

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

[`BigFloat`](@ref) 操作のデフォルトの精度（有効数字のビット数）と丸めモードは、[`setprecision`](@ref) および [`setrounding`](@ref) を呼び出すことでグローバルに変更できます。これにより、以降のすべての計算はこれらの変更を考慮します。 あるいは、特定のコードブロックの実行中のみ精度や丸めを変更することも可能で、その場合は同じ関数を `do` ブロックと共に使用します。

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
    [`setprecision`](@ref) または [`setrounding`](@ref) と [`@big_str`](@ref) の関係は、`big` 文字列リテラル（例えば `big"0.3"`）に使用されるマクロであるため、直感的ではないかもしれません。詳細については、`4d61726b646f776e2e436f64652822222c2022406269675f7374722229_40726566` のドキュメントを参照してください。


## [Numeric Literal Coefficients](@id man-numeric-literal-coefficients)

一般的な数式や表現を明確にするために、Juliaでは変数の前に数値リテラルを置くことができ、乗算を暗示します。これにより、多項式の表現がよりクリーンになります：

```jldoctest numeric-coefficients
julia> x = 3
3

julia> 2x^2 - 3x + 1
10

julia> 1.5x^2 - .5x + 1
13.0
```

指数関数を書くことがよりエレガントになります：

```jldoctest numeric-coefficients
julia> 2^2x
64
```

数値リテラル係数の優先順位は、否定などの単項演算子の優先順位よりもわずかに低いです。したがって、`-2x`は`(-2) * x`として解析され、`√2x`は`(√2) * x`として解析されます。しかし、数値リテラル係数は、累乗と組み合わせると単項演算子と似たように解析されます。例えば、`2^3x`は`2^(3x)`として解析され、`2x^3`は`2*(x^3)`として解析されます。

数値リテラルは、括弧付きの式の係数としても機能します：

```jldoctest numeric-coefficients
julia> 2(x-1)^2 - 3(x-1) + 1
3
```

!!! note
    数値リテラル係数の暗黙の乗算に使用される優先順位は、乗算（`*`）や除算（`/`、`\`、および `//`）などの他の二項演算子よりも高いです。 これは、例えば `1 / 2im` が `-0.5im` に等しく、`6 // 2(2 + 1)` が `1 // 1` に等しいことを意味します。


さらに、括弧付きの式は変数の係数として使用でき、式を変数で乗算することを意味します：

```jldoctest numeric-coefficients
julia> (x-1)x
6
```

二つの括弧付き表現の並置や、括弧付き表現の前に変数を置くことは、いずれも乗算を暗示するためには使用できません：

```jldoctest numeric-coefficients
julia> (x-1)(x+1)
ERROR: MethodError: objects of type Int64 are not callable

julia> x(x+1)
ERROR: MethodError: objects of type Int64 are not callable
```

両方の式は関数適用として解釈されます：数値リテラルでない任意の式が、すぐに括弧に続く場合、その式は括弧内の値に適用される関数として解釈されます（関数についての詳細は [Functions](@ref) を参照してください）。したがって、これらのケースの両方で、左側の値が関数でないためエラーが発生します。

上記の構文強化は、一般的な数学的公式を書く際に発生する視覚的ノイズを大幅に減少させます。数値リテラルの係数と、それが掛け算する識別子または括弧付きの表現の間に空白を入れてはいけないことに注意してください。

### Syntax Conflicts

対比されたリテラル係数構文は、いくつかの数値リテラル構文、すなわち16進数、8進数、2進数の整数リテラルおよび浮動小数点リテラルの工学表記と衝突する可能性があります。以下は、構文の衝突が発生するいくつかの状況です：

  * 16進数整数リテラル式 `0xff` は、数値リテラル `0` が変数 `xff` に掛けられていると解釈される可能性があります。同様の曖昧さは、8進数や2進数リテラル `0o777` や `0b01001010` にも見られます。
  * 浮動小数点リテラル式 `1e10` は、数値リテラル `1` が変数 `e10` で掛けられていると解釈される可能性があります。同様に、同等の `E` 形式でも同じです。
  * 32ビット浮動小数点リテラル式 `1.5f22` は、数値リテラル `1.5` が変数 `f22` で乗算されていると解釈される可能性があります。

すべての場合において、あいまいさは数値リテラルとしての解釈を支持する形で解決されます：

  * `0x`/`0o`/`0b`で始まる表現は常に16進数/8進数/2進数リテラルです。
  * 数値リテラルで始まり、その後に `e` または `E` が続く式は常に浮動小数点リテラルです。
  * 数値リテラルで始まり、その後に `f` が続く式は常に32ビット浮動小数点リテラルです。

`E`が歴史的な理由から数値リテラルにおいて`e`と同等であるのに対し、`F`は単なる別の文字であり、数値リテラルにおいて`f`のようには振る舞いません。したがって、数値リテラルの後に`F`が続く式は、数値リテラルが変数で乗算されるものとして解釈されます。つまり、例えば`1.5F22`は`1.5 * F22`と等しいです。

## Literal zero and one

Juliaは、指定された型または与えられた変数の型に対応するリテラル0および1を返す関数を提供します。

| Function          | Description                                      |
|:----------------- |:------------------------------------------------ |
| [`zero(x)`](@ref) | Literal zero of type `x` or type of variable `x` |
| [`one(x)`](@ref)  | Literal one of type `x` or type of variable `x`  |

これらの関数は、不要な [type conversion](@ref conversion-and-promotion) からのオーバーヘッドを回避するために [Numeric Comparisons](@ref) で役立ちます。

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
