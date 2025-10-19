```julia
rotr90(A)
```

行列 `A` を右に90度回転させます。

# 例

```jldoctest
julia> a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> rotr90(a)
2×2 Matrix{Int64}:
 3  1
 4  2
```
