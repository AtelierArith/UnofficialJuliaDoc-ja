```julia
eigvecs(A, B) -> Matrix
```

列が `A` と `B` の一般化固有ベクトルである行列 `M` を返します。（`k` 番目の固有ベクトルは、スライス `M[:, k]` から取得できます。）

# Examples

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
