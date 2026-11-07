```julia
(\)(F::QRSparse, B::StridedVecOrMat)
```

``\min\|Ax - b\|^2`` の最小二乗問題、または `F` が ``A`` の疎 QR 分解である場合の連立一次方程式 ``Ax=b`` を解きます。問題が劣決定の場合は、基本解を返します。

# Examples

```jldoctest
julia> A = sparse([1,2,4], [1,1,1], [1.0,1.0,1.0], 4, 2)
4×2 SparseMatrixCSC{Float64, Int64} with 3 stored entries:
 1.0   ⋅
 1.0   ⋅
  ⋅    ⋅
 1.0   ⋅

julia> qr(A)\fill(1.0, 4)
2-element Vector{Float64}:
 1.0
 0.0
```
