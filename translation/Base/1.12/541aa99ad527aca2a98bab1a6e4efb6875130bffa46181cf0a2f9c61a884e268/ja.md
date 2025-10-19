```julia
any(A; dims)
```

与えられた配列の指定された次元に沿って、値が `true` であるかどうかをテストします。

# 例

```jldoctest
julia> A = [true false; true false]
2×2 Matrix{Bool}:
 1  0
 1  0

julia> any(A, dims=1)
1×2 Matrix{Bool}:
 1  0

julia> any(A, dims=2)
2×1 Matrix{Bool}:
 1
 1
```
