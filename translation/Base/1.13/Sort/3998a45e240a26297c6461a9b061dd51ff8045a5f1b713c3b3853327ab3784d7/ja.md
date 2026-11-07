```julia
sort(A; dims::Integer, alg::Base.Sort.Algorithm=Base.Sort.defalg(A), lt=isless, by=identity, rev::Bool=false, order::Base.Order.Ordering=Base.Order.Forward)
```

多次元配列 `A` を、指定した次元に沿ってソートします。使用可能なキーワード引数については、[`sort!`](@ref) を参照してください。

配列のスライスをソートする方法については、[`sortslices`](@ref) を参照してください。

# Examples

```jldoctest
julia> A = [4 3; 1 2]
2×2 Matrix{Int64}:
 4  3
 1  2

julia> sort(A, dims = 1)
2×2 Matrix{Int64}:
 1  2
 4  3

julia> sort(A, dims = 2)
2×2 Matrix{Int64}:
 3  4
 1  2
```
