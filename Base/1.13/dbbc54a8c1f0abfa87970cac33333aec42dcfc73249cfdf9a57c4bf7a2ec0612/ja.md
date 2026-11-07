```julia
round(z::Complex[, RoundingModeReal, [RoundingModeImaginary]])
round(z::Complex[, RoundingModeReal, [RoundingModeImaginary]]; digits=0, base=10)
round(z::Complex[, RoundingModeReal, [RoundingModeImaginary]]; sigdigits, base=10)
```

複素数値 `z` と同じ型で、`z` に最も近い整数値を返します。等距離の候補がある場合は、指定された [`RoundingMode`](@ref) に従って決定します。1 つ目の [`RoundingMode`](@ref) は実部の丸めに、2 つ目は虚部の丸めに使用されます。

`RoundingModeReal` と `RoundingModeImaginary` のデフォルトは [`RoundNearest`](@ref) です。これは最も近い整数に丸め、等距離の候補がある場合（小数部分が 0.5 の場合）は最も近い偶数に丸めます。

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
