```
(\)(F::QRSparse, B::StridedVecOrMat)
```

最小二乗問題 $\min\|Ax - b\|^2$ または線形方程式系 $Ax=b$ を解きます。ここで `F` は $A$ のスパースQR因子分解です。問題が過剰決定されている場合、基本的な解が返されます。

# 例

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
