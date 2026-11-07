```julia
svdvals(A, B)
```

`A` と `B` の一般化特異値分解から、一般化特異値を返します。[`svd`](@ref) も参照してください。

# Examples

```jldoctest
julia> A = [1. 0.; 0. -1.]
2×2 Matrix{Float64}:
 1.0   0.0
 0.0  -1.0

julia> B = [0. 1.; 1. 0.]
2×2 Matrix{Float64}:
 0.0  1.0
 1.0  0.0

julia> svdvals(A, B)
2-element Vector{Float64}:
 1.0
 1.0
```
