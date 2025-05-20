```
clamp!(array::AbstractArray, lo, hi)
```

`array`内の値を指定された範囲に制限します（インプレース）。詳細は[`clamp`](@ref)を参照してください。

!!! compat "Julia 1.3"
    `array`内の`missing`エントリには、少なくともJulia 1.3が必要です。


# 例

```jldoctest
julia> row = collect(-4:4)';

julia> clamp!(row, 0, Inf)
1×9 adjoint(::Vector{Int64}) with eltype Int64:
 0  0  0  0  0  1  2  3  4

julia> clamp.((-4:4)', 0, Inf)
1×9 Matrix{Float64}:
 0.0  0.0  0.0  0.0  0.0  1.0  2.0  3.0  4.0
```
