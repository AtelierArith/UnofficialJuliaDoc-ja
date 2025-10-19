```julia
sort!(A; dims::Integer, alg::Base.Sort.Algorithm=Base.Sort.defalg(A), lt=isless, by=identity, rev::Bool=false, order::Base.Order.Ordering=Base.Order.Forward)
```

多次元配列 `A` を次元 `dims` に沿ってソートします。可能なキーワード引数の説明については、[`sort!`](@ref) の一次元バージョンを参照してください。

配列のスライスをソートするには、[`sortslices`](@ref) を参照してください。

!!! compat "Julia 1.1"
    この関数は少なくとも Julia 1.1 を必要とします。


# 例

```jldoctest
julia> A = [4 3; 1 2]
2×2 Matrix{Int64}:
 4  3
 1  2

julia> sort!(A, dims = 1); A
2×2 Matrix{Int64}:
 1  2
 4  3

julia> sort!(A, dims = 2); A
2×2 Matrix{Int64}:
 1  2
 3  4
```
