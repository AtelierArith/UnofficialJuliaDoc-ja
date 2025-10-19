```julia
rot180(A, k)
```

行列 `A` を180度、整数 `k` 回回転させます。`k` が偶数の場合、これは `copy` と同等です。

# 例

```jldoctest
julia> a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> rot180(a,1)
2×2 Matrix{Int64}:
 4  3
 2  1

julia> rot180(a,2)
2×2 Matrix{Int64}:
 1  2
 3  4
```
