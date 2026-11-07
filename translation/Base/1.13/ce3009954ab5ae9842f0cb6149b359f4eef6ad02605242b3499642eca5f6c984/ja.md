```julia
zeros([T=Float64,] dims::Tuple)
zeros([T=Float64,] dims...)
```

サイズを`dims`で指定した、要素型が`T`の、すべての要素がゼロの`Array`を作成します。[`fill`](@ref)、[`ones`](@ref)、[`zero`](@ref)も参照してください。

# Examples

```jldoctest
julia> zeros(1)
1-element Vector{Float64}:
 0.0

julia> zeros(Int8, 2, 3)
2×3 Matrix{Int8}:
 0  0  0
 0  0  0
```
