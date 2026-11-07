```julia
ones([T=Float64,] dims::Tuple)
ones([T=Float64,] dims...)
```

`Array`を作成します。要素型は`T`で、サイズは`dims`で指定し、すべての要素を1にします。[`fill`](@ref)、[`zeros`](@ref)も参照してください。

# Examples

```jldoctest
julia> ones(1,2)
1×2 Matrix{Float64}:
 1.0  1.0

julia> ones(ComplexF64, 2, 3)
2×3 Matrix{ComplexF64}:
 1.0+0.0im  1.0+0.0im  1.0+0.0im
 1.0+0.0im  1.0+0.0im  1.0+0.0im
```
