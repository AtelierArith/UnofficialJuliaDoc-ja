```julia
round(z::Complex[, RoundingModeReal, [RoundingModeImaginary]])
round(z::Complex[, RoundingModeReal, [RoundingModeImaginary]]; digits=0, base=10)
round(z::Complex[, RoundingModeReal, [RoundingModeImaginary]]; sigdigits, base=10)
```

複素数値の `z` に最も近い整数値を、`z` と同じ型で返します。同距離の場合は、指定された [`RoundingMode`](@ref) に従って丸めます。1つ目の [`RoundingMode`](@ref) は実部の丸めに、2つ目は虚部の丸めに使われます。

`RoundingModeReal` と `RoundingModeImaginary` の既定値は [`RoundNearest`](@ref) です。これは最も近い整数に丸め、同距離の場合（小数部が 0.5 の場合）は偶数の整数に丸めます。

# Examples

```jldoctest
julia> round(3.14 + 4.5im)
3.0 + 4.0im

julia> round(3.14 + 4.5im, RoundUp, RoundNearestTiesUp)
4.0 + 5.0im

julia> round(3.14159 + 4.512im; digits = 1)
3.1 + 4.5im

julia> round(3.14159 + 4.512im; sigdigits = 3)
3.14 + 4.51im
```
