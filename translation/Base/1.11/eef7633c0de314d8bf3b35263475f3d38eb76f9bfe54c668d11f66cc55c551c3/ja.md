```
rotl90(A)
```

行列 `A` を左に90度回転させます。

# 例

```jldoctest
julia> a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> rotl90(a)
2×2 Matrix{Int64}:
 2  4
 1  3
```
