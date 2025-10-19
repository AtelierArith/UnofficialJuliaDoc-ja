```julia
diagview(M, k::Integer=0)
```

行列 `M` の `k` 番目の対角線へのビューを返します。

他にも [`diag`](@ref)、[`diagind`](@ref) を参照してください。

!!! compat "Julia 1.12"
    この関数は Julia 1.12 以降が必要です。


# 例

```jldoctest
julia> A = [1 2 3; 4 5 6; 7 8 9]
3×3 Matrix{Int64}:
 1  2  3
 4  5  6
 7  8  9

julia> diagview(A)
3-element view(::Vector{Int64}, 1:4:9) with eltype Int64:
 1
 5
 9

julia> diagview(A, 1)
2-element view(::Vector{Int64}, 4:4:8) with eltype Int64:
 2
 6
```
