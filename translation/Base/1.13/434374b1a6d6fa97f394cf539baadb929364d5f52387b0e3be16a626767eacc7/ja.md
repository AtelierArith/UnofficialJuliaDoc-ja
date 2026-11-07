```julia
round([T,] x, [r::RoundingMode])
round(x, [r::RoundingMode]; digits::Integer=0, base = 10)
round(x, [r::RoundingMode]; sigdigits::Integer, base = 10)
```

数値 `x` を丸めます。

キーワード引数を指定しない場合、`x` は整数値に丸められ、型 `T` の値を返します。ただし、`T` が指定されていない場合は、`x` と同じ型の値を返します。値を `T` で表現できない場合は、[`convert`](@ref) と同様に、[`InexactError`](@ref) がスローされます。

キーワード引数 `digits` を指定すると、基数 `base` で、小数点以下（`digits` が負の場合は小数点より前）の指定桁数に丸めます。

キーワード引数 `sigdigits` を指定すると、基数 `base` で、指定した有効桁数に丸めます。

[`RoundingMode`](@ref) `r` は丸めの方向を制御します。デフォルトは [`RoundNearest`](@ref) で、最も近い整数に丸めます。ちょうど中間の値（小数部が 0.5 の値）は、最も近い偶数の整数に丸められます。グローバルな丸めモードを変更すると、`round` が誤った結果を返す場合があることに注意してください（[`rounding`](@ref) を参照）。

浮動小数点型に丸める場合、真の整数ではなく、その型で表現可能な整数（および Inf）に丸めます。「最も近い値」を判定する際、Inf は `floatmax(T)` より 1 ulp 大きい値として扱われます。これは [`convert`](@ref) と同様です。

# Examples

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
    2 以外の基数で指定桁数に丸める場合、2 進浮動小数点数を扱うと正確に丸められないことがあります。たとえば、[`Float64`](@ref) の値は `1.15` で表されますが、実際には 1.15 より *小さい* 値です。それでも 1.2 に丸められます。例：

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

`round` を新しい数値型に拡張するには、通常、`Base.round(x::NewType, r::RoundingMode)` を定義するだけで十分です。
