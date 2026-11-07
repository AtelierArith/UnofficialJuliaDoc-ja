```julia
eigvals(A; permute::Bool=true, scale::Bool=true, sortby) -> values
```

`A` の固有値を返します。

一般の非対称行列では、固有値を計算する前に行列をどのようにバランス調整するかを指定できます。キーワード `permute`、`scale`、`sortby` は、[`eigen`](@ref) と同じです。

# Examples

```jldoctest
julia> diag_matrix = [1 0; 0 4]
2×2 Matrix{Int64}:
 1  0
 0  4

julia> eigvals(diag_matrix)
2-element Vector{Float64}:
 1.0
 4.0
```
