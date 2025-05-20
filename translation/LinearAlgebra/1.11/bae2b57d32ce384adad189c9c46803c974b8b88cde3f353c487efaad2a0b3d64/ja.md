```
eigvecs(A, B) -> Matrix
```

行列 `M` を返します。`M` の列は `A` と `B` の一般化固有ベクトルです。`k` 番目の固有ベクトルはスライス `M[:, k]` から取得できます。

# 例

```jldoctest
julia> A = [1 0; 0 -1]
2×2 Matrix{Int64}:
 1   0
 0  -1

julia> B = [0 1; 1 0]
2×2 Matrix{Int64}:
 0  1
 1  0

julia> eigvecs(A, B)
2×2 Matrix{ComplexF64}:
  0.0+1.0im   0.0-1.0im
 -1.0+0.0im  -1.0-0.0im
```
