# Complex and Rational Numbers

Juliaには複素数と有理数の組み込み型があり、これらに対する標準的な[Mathematical Operations and Elementary Functions](@ref)をすべてサポートしています。[Conversion and Promotion](@ref conversion-and-promotion)は、プリミティブ型か複合型かを問わず、組み込みの数値型をどのように組み合わせても、演算が期待どおりに動作するよう定義されています。

## Complex Numbers

グローバル定数[`im`](@ref)には、-1の主平方根を表す複素数*i*が束縛されています。（このグローバル定数に数学者が使う`i`や、技術者が使う`j`を採用しなかったのは、どちらも添字変数名として非常によく使われるためです。）Juliaでは数値リテラルを[juxtaposed with identifiers as coefficients](@ref man-numeric-literal-coefficients)できるため、この束縛だけで、従来の数学表記と同様に複素数を簡潔に記述できます。

```jldoctest
julia> 1+2im
1 + 2im
```

複素数に対して、標準的な算術演算をすべて実行できます。

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

型昇格の仕組みにより、異なる型のオペランドを組み合わせても、そのまま期待どおりに動作します。

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

`3/4im == 3/(4*im) == -(3/4*im)`に注意してください。リテラル係数は除算よりも強く結合するためです。

複素数を操作する標準関数も用意されています。

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

通常、複素数の絶対値（[`abs`](@ref)）は、原点からの距離です。[`abs2`](@ref)は絶対値の二乗を返します。平方根を計算せずに済むため、複素数では特に便利です。[`angle`](@ref)は位相角をラジアンで返します（*argument*または*arg*関数とも呼ばれます）。複素数には、その他の[Elementary Functions](@ref)も一通り定義されています。

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

数学関数は通常、実数に適用すると実数値を、複素数に適用すると複素数値を返します。たとえば、[`sqrt`](@ref)は、`-1`に適用した場合と`-1 + 0im`に適用した場合とで動作が異なります。`-1 == -1 + 0im`であるにもかかわらずです。

```jldoctest
julia> sqrt(-1)
ERROR: DomainError with -1.0:
sqrt was called with a negative real argument but will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
Stacktrace:
[...]

julia> sqrt(-1 + 0im)
0.0 + 1.0im
```

変数から複素数を構築する場合、[literal numeric coefficient notation](@ref man-numeric-literal-coefficients)は使えません。その場合は、乗算を明示的に記述する必要があります。

```jldoctest
julia> a = 1; b = 2; a + b*im
1 + 2im
```

ただし、この方法は*推奨されません*。代わりに、実部と虚部から複素数を直接構築する、より効率的な[`complex`](@ref)関数を使ってください。

```jldoctest
julia> a = 1; b = 2; complex(a, b)
1 + 2im
```

この方法なら、乗算や加算を行わずに済みます。

[`Inf`](@ref)と[`NaN`](@ref)は、[Special floating-point values](@ref)の節で説明されているとおり、複素数の実部と虚部を通じて複素数に伝播します。

```jldoctest
julia> 1 + Inf*im
1.0 + Inf*im

julia> 1 + NaN*im
1.0 + NaN*im
```

## Rational Numbers

Juliaには、整数の比を正確に表す有理数型があります。有理数は[`//`](@ref)演算子を使って構築します。

```jldoctest
julia> 2//3
2//3
```

有理数の分子と分母に共通因子がある場合は、分母が非負になるよう、既約分数に約分されます。

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

整数の比をこのように正規化した形は一意です。そのため、分子と分母がそれぞれ等しいかどうかを調べれば、有理数の等価性を判定できます。有理数の正規化された分子と分母は、[`numerator`](@ref)関数と[`denominator`](@ref)関数で取得できます。

```jldoctest
julia> numerator(2//3)
2

julia> denominator(2//3)
3
```

分子と分母を直接比較する必要は通常ありません。有理数には、標準的な算術演算と比較演算が定義されているためです。

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

有理数は簡単に浮動小数点数へ変換できます。

```jldoctest
julia> float(3//4)
0.75
```

有理数から浮動小数点数への変換では、`a==0 && b <= 0`の場合を除き、`a`と`b`が任意の整数値であるとき、次の恒等式が成り立ちます。

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

無限大の有理数を構築することは問題ありません。

```jldoctest
julia> 5//0
1//0

julia> x = -3//0
-1//0

julia> typeof(x)
Rational{Int64}
```

一方、[`NaN`](@ref)の有理数を構築しようとすると、エラーになります。

```jldoctest
julia> 0//0
ERROR: ArgumentError: invalid rational: zero(Int64)//zero(Int64)
Stacktrace:
[...]
```

通常どおり、型昇格システムにより、ほかの数値型との組み合わせも簡単に扱えます。

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
