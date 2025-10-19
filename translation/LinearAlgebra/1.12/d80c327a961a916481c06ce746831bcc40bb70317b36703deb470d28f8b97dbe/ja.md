```julia
eigvals(A; permute::Bool=true, scale::Bool=true, sortby) -> values
```

行列 `A` の固有値を返します。

一般的な非対称行列に対しては、固有値計算の前に行列がどのようにバランスされるかを指定することが可能です。`permute`、`scale`、および `sortby` キーワードは [`eigen`](@ref) と同じです。

# 例

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
