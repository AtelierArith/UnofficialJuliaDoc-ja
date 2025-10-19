```julia
diag(M, k::Integer=0)
```

行列の `k` 番目の対角線をベクトルとして返します。

関連項目としては [`diagm`](@ref), [`diagind`](@ref), [`Diagonal`](@ref), [`isdiag`](@ref) があります。

# 例

```jldoctest
julia> A = [1 2 3; 4 5 6; 7 8 9]
3×3 Matrix{Int64}:
 1  2  3
 4  5  6
 7  8  9

julia> diag(A,1)
2-element Vector{Int64}:
 2
 6
```
