# Complex and Rational Numbers

Julia には、複素数と有理数のための事前定義された型が含まれており、これらに対してすべての標準 [Mathematical Operations and Elementary Functions](@ref) をサポートしています。 [Conversion and Promotion](@ref conversion-and-promotion) は、プリミティブ型または複合型のいずれかの事前定義された数値型の組み合わせに対して、期待通りに動作するように定義されています。

## Complex Numbers

グローバル定数 [`im`](@ref) は複素数 *i* にバインドされており、-1 の主平方根を表しています。（数学者の `i` やエンジニアの `j` をこのグローバル定数に使用することは、非常に一般的なインデックス変数名であるため却下されました。）Julia は数値リテラルを [juxtaposed with identifiers as coefficients](@ref man-numeric-literal-coefficients) のように許可しているため、このバインディングは複素数のための便利な構文を提供するのに十分であり、従来の数学的表記法に似ています：

```jldoctest
julia> 1+2im
1 + 2im
```

複素数に対してすべての標準的な算術演算を行うことができます：

```jldoctest
julia> (1 + 2im)*(2 - 3im)
8 + 1im

julia> (1 + 2im)/(1 - 2im)
-0.6 + 0.8im

julia> (1 + 2im) + (1 - 2im)
2 + 0im

julia> (-3 + 2im) - (5 - 1im)
-8 + 3im

julia> (-1 + 2im)^2
-3 - 4im

julia> (-1 + 2im)^2.5
2.729624464784009 - 6.9606644595719im

julia> (-1 + 2im)^(1 + 1im)
-0.27910381075826657 + 0.08708053414102428im

julia> 3(2 - 5im)
6 - 15im

julia> 3(2 - 5im)^2
-63 - 60im

julia> 3(2 - 5im)^-1.0
0.20689655172413793 + 0.5172413793103449im
```

昇格メカニズムは、異なる型のオペランドの組み合わせがうまく機能することを保証します：

```jldoctest
julia> 2(1 - 1im)
2 - 2im

julia> (2 + 3im) - 1
1 + 3im

julia> (1 + 2im) + 0.5
1.5 + 2.0im

julia> (2 + 3im) - 0.5im
2.0 + 2.5im

julia> 0.75(1 + 2im)
0.75 + 1.5im

julia> (2 + 3im) / 2
1.0 + 1.5im

julia> (1 - 3im) / (2 + 2im)
-0.5 - 1.0im

julia> 2im^2
-2 + 0im

julia> 1 + 3/4im
1.0 - 0.75im
```

`3/4im == 3/(4*im) == -(3/4*im)`に注意してください。リテラル係数は除算よりも強く結びつくためです。

複素値を操作するための標準関数が提供されています：

```jldoctest
julia> z = 1 + 2im
1 + 2im

julia> real(1 + 2im) # real part of z
1

julia> imag(1 + 2im) # imaginary part of z
2

julia> conj(1 + 2im) # complex conjugate of z
1 - 2im

julia> abs(1 + 2im) # absolute value of z
2.23606797749979

julia> abs2(1 + 2im) # squared absolute value
5

julia> angle(1 + 2im) # phase angle in radians
1.1071487177940904
```

通常、複素数の絶対値（[`abs`](@ref)）はゼロからの距離です。[`abs2`](@ref)は絶対値の二乗を返し、平方根を取ることを避けるため、複素数に特に便利です。[`angle`](@ref)はラジアンでの位相角（*argument*または*arg*関数としても知られています）を返します。複素数に対して定義されている他のすべての[Elementary Functions](@ref)もあります：

```jldoctest
julia> sqrt(1im)
0.7071067811865476 + 0.7071067811865475im

julia> sqrt(1 + 2im)
1.272019649514069 + 0.7861513777574233im

julia> cos(1 + 2im)
2.0327230070196656 - 3.0518977991517997im

julia> exp(1 + 2im)
-1.1312043837568135 + 2.4717266720048188im

julia> sinh(1 + 2im)
-0.4890562590412937 + 1.4031192506220405im
```

数学関数は通常、実数に適用されると実数値を返し、複素数に適用されると複素数値を返すことに注意してください。たとえば、[`sqrt`](@ref) は `-1` に適用される場合と `-1 + 0im` に適用される場合で異なる動作をしますが、`-1 == -1 + 0im` です。

```jldoctest
julia> sqrt(-1)
ERROR: DomainError with -1.0:
sqrt was called with a negative real argument but will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
Stacktrace:
[...]

julia> sqrt(-1 + 0im)
0.0 + 1.0im
```

[literal numeric coefficient notation](@ref man-numeric-literal-coefficients) は、変数から複素数を構築する際に機能しません。代わりに、乗算を明示的に書き出す必要があります：

```jldoctest
julia> a = 1; b = 2; a + b*im
1 + 2im
```

しかし、これは*推奨されません*。代わりに、より効率的な [`complex`](@ref) 関数を使用して、実部と虚部から直接複素値を構築してください：

```jldoctest
julia> a = 1; b = 2; complex(a, b)
1 + 2im
```

この構造は、乗算と加算の操作を回避します。

[`Inf`](@ref) と [`NaN`](@ref) は、[Special floating-point values](@ref) セクションで説明されているように、複素数の実部と虚部を通じて伝播します。

```jldoctest
julia> 1 + Inf*im
1.0 + Inf*im

julia> 1 + NaN*im
1.0 + NaN*im
```

## Rational Numbers

ジュリアは整数の正確な比率を表すための有理数型を持っています。有理数は [`//`](@ref) 演算子を使用して構築されます：

```jldoctest
julia> 2//3
2//3
```

有理数の分子と分母に共通の因子がある場合、それらは最小項に簡約され、分母は非負となります：

```jldoctest
julia> 6//9
2//3

julia> -4//8
-1//2

julia> 5//-15
-1//3

julia> -4//-12
1//3
```

この整数の比の正規化された形は一意であるため、有理数の値の等価性は分子と分母の等価性を確認することでテストできます。有理数の標準化された分子と分母は、[`numerator`](@ref) および [`denominator`](@ref) 関数を使用して抽出できます：

```jldoctest
julia> numerator(2//3)
2

julia> denominator(2//3)
3
```

分子と分母の直接比較は一般的に必要ありません。なぜなら、標準的な算術および比較演算は有理値に対して定義されているからです。

```jldoctest
julia> 2//3 == 6//9
true

julia> 2//3 == 9//27
false

julia> 3//7 < 1//2
true

julia> 3//4 > 2//3
true

julia> 2//4 + 1//6
2//3

julia> 5//12 - 1//4
1//6

julia> 5//8 * 3//12
5//32

julia> 6//5 / 10//7
21//25
```

有理数は簡単に浮動小数点数に変換できます：

```jldoctest
julia> float(3//4)
0.75
```

有理数から浮動小数点数への変換は、`a` と `b` の任意の整数値に対して次の恒等式を尊重します。ただし、`a==0 && b <= 0` の場合を除きます:

```jldoctest
julia> a = 1; b = 2;

julia> isequal(float(a//b), a/b)
true

julia> a, b = 0, 0
(0, 0)

julia> float(a//b)
ERROR: ArgumentError: invalid rational: zero(Int64)//zero(Int64)
Stacktrace:
[...]

julia> a/b
NaN

julia> a, b = 0, -1
(0, -1)

julia> float(a//b), a/b
(0.0, -0.0)
```

無限の有理値を構築することは許可されています：

```jldoctest
julia> 5//0
1//0

julia> x = -3//0
-1//0

julia> typeof(x)
Rational{Int64}
```

[`NaN`](@ref)という有理値を構築しようとしていますが、無効です：

```jldoctest
julia> 0//0
ERROR: ArgumentError: invalid rational: zero(Int64)//zero(Int64)
Stacktrace:
[...]
```

通常通り、昇格システムは他の数値型との相互作用を容易にします：

```jldoctest
julia> 3//5 + 1
8//5

julia> 3//5 - 0.5
0.09999999999999998

julia> 2//7 * (1 + 2im)
2//7 + 4//7*im

julia> 2//7 * (1.5 + 2im)
0.42857142857142855 + 0.5714285714285714im

julia> 3//2 / (1 + 2im)
3//10 - 3//5*im

julia> 1//2 + 2im
1//2 + 2//1*im

julia> 1 + 2//3im
1//1 - 2//3*im

julia> 0.5 == 1//2
true

julia> 0.33 == 1//3
false

julia> 0.33 < 1//3
true

julia> 1//3 - 0.33
0.0033333333333332993
```
