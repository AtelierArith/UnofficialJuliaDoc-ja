```
ones([T=Float64,] dims::Tuple)
ones([T=Float64,] dims...)
```

指定されたサイズ `dims` のすべての要素が1の `Array` を作成します。詳細は [`fill`](@ref)、[`zeros`](@ref) を参照してください。

# 例

```jldoctest
julia> ones(1,2)
1×2 Matrix{Float64}:
 1.0  1.0

julia> ones(ComplexF64, 2, 3)
2×3 Matrix{ComplexF64}:
 1.0+0.0im  1.0+0.0im  1.0+0.0im
 1.0+0.0im  1.0+0.0im  1.0+0.0im
```
