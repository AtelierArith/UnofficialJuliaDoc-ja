```
sort(A; dims::Integer, alg::Algorithm=defalg(A), lt=isless, by=identity, rev::Bool=false, order::Ordering=Forward)
```

与えられた次元に沿って多次元配列 `A` をソートします。可能なキーワード引数の説明については [`sort!`](@ref) を参照してください。

配列のスライスをソートするには、[`sortslices`](@ref) を参照してください。

# 例

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
