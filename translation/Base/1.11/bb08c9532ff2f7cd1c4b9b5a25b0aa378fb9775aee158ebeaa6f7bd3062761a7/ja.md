```
zeros([T=Float64,] dims::Tuple)
zeros([T=Float64,] dims...)
```

指定されたサイズ `dims` のすべての要素がゼロの型 `T` の `Array` を作成します。詳細は [`fill`](@ref)、[`ones`](@ref)、[`zero`](@ref) を参照してください。

# 例

```jldoctest
julia> zeros(1)
1-element Vector{Float64}:
 0.0

julia> zeros(Int8, 2, 3)
2×3 Matrix{Int8}:
 0  0  0
 0  0  0
```
