```julia
clamp!(array::AbstractArray, lo, hi)
```

`array`の値を、指定した範囲内にその場で制限します。[`clamp`](@ref)も参照してください。

!!! compat "Julia 1.3"
    `array`内の`missing`エントリを使用するには、Julia 1.3以降が必要です。


# Examples

```jldoctest
julia> row = collect(-4:4)';

julia> clamp!(row, 0, Inf)
1×9 adjoint(::Vector{Int64}) with eltype Int64:
 0  0  0  0  0  1  2  3  4

julia> clamp.((-4:4)', 0, Inf)
1×9 Matrix{Float64}:
 0.0  0.0  0.0  0.0  0.0  1.0  2.0  3.0  4.0
```
