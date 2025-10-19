```julia
all(p, A; dims)
```

与えられた配列の指定された次元に沿って、述語 `p` がすべての要素に対して `true` を返すかどうかを判断します。

# 例

```jldoctest
julia> A = [1 -1; 2 2]
2×2 Matrix{Int64}:
 1  -1
 2   2

julia> all(i -> i > 0, A, dims=1)
1×2 Matrix{Bool}:
 1  0

julia> all(i -> i > 0, A, dims=2)
2×1 Matrix{Bool}:
 0
 1
```
