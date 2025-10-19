```julia
all(A; dims)
```

与えられた配列の指定された次元に沿ってすべての値が `true` であるかどうかをテストします。

# 例

```jldoctest
julia> A = [true false; true true]
2×2 Matrix{Bool}:
 1  0
 1  1

julia> all(A, dims=1)
1×2 Matrix{Bool}:
 1  0

julia> all(A, dims=2)
2×1 Matrix{Bool}:
 0
 1
```
