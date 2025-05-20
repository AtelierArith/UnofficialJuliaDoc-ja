```
round(z::Complex[, RoundingModeReal, [RoundingModeImaginary]])
round(z::Complex[, RoundingModeReal, [RoundingModeImaginary]]; digits=0, base=10)
round(z::Complex[, RoundingModeReal, [RoundingModeImaginary]]; sigdigits, base=10)
```

複素数 `z` に対して同じ型の最も近い整数値を返します。指定された [`RoundingMode`](@ref) を使用して、結びつきを解消します。最初の [`RoundingMode`](@ref) は実数成分の丸めに使用され、2 番目は虚数成分の丸めに使用されます。

`RoundingModeReal` と `RoundingModeImaginary` はデフォルトで [`RoundNearest`](@ref) に設定されており、これは最も近い整数に丸めます。結びつき（0.5 の分数値）は最も近い偶数に丸められます。

# 例

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
