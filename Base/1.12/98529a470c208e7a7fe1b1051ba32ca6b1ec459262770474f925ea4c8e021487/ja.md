```julia
round([T,] x, [r::RoundingMode])
round(x, [r::RoundingMode]; digits::Integer=0, base = 10)
round(x, [r::RoundingMode]; sigdigits::Integer, base = 10)
```

数値 `x` を四捨五入します。

キーワード引数なしで、`x` は整数値に四捨五入され、`T` が提供されていない場合は `x` と同じ型の値が返されます。値が `T` で表現できない場合、[`InexactError`](@ref) がスローされます。これは [`convert`](@ref) に似ています。

`digits` キーワード引数が提供されると、小数点以下（または負の場合は小数点前）の指定された桁数に四捨五入されます。基数は `base` です。

`sigdigits` キーワード引数が提供されると、指定された有効桁数に四捨五入されます。基数は `base` です。

[`RoundingMode`](@ref) `r` は四捨五入の方向を制御します。デフォルトは [`RoundNearest`](@ref) で、最も近い整数に四捨五入され、0.5 の分数値は最も近い偶数の整数に四捨五入されます。グローバルな四捨五入モードが変更されると、`round` が不正確な結果を返す可能性があることに注意してください（[`rounding`](@ref）を参照）。

浮動小数点型に四捨五入する場合、その型で表現可能な整数（および Inf）に四捨五入され、真の整数にはなりません。Inf は「最も近い」を決定する目的で `floatmax(T)` よりも 1 ulp 大きいものとして扱われ、[`convert`](@ref) に似ています。

# 例

```jldoctest
julia> round(1.7)
2.0

julia> round(Int, 1.7)
2

julia> round(1.5)
2.0

julia> round(2.5)
2.0

julia> round(pi; digits=2)
3.14

julia> round(pi; digits=3, base=2)
3.125

julia> round(123.456; sigdigits=2)
120.0

julia> round(357.913; sigdigits=4, base=2)
352.0

julia> round(Float16, typemax(UInt128))
Inf16

julia> floor(Float16, typemax(UInt128))
Float16(6.55e4)
```

!!! note
    2 以外の基数で指定された桁数に四捨五入することは、バイナリ浮動小数点数で操作する場合に不正確な場合があります。たとえば、`1.15` で表される [`Float64`](@ref) の値は実際には 1.15 よりも *小さい* ですが、1.2 に四捨五入されます。たとえば：

    ```jldoctest
    julia> x = 1.15
    1.15

    julia> big(1.15)
    1.149999999999999911182158029987476766109466552734375

    julia> x < 115//100
    true

    julia> round(x, digits=1)
    1.2
    ```


# Extensions

`round` を新しい数値型に拡張するには、通常 `Base.round(x::NewType, r::RoundingMode)` を定義するだけで十分です。
