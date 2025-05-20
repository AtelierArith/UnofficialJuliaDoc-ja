```
rotr90(A, k)
```

行列 `A` を整数 `k` 回時計回りに90度右回転させます。`k` が4の倍数（ゼロを含む）の場合、これは `copy` と同等です。

# 例

```jldoctest
julia> a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> rotr90(a,1)
2×2 Matrix{Int64}:
 3  1
 4  2

julia> rotr90(a,2)
2×2 Matrix{Int64}:
 4  3
 2  1

julia> rotr90(a,3)
2×2 Matrix{Int64}:
 2  4
 1  3

julia> rotr90(a,4)
2×2 Matrix{Int64}:
 1  2
 3  4
```
