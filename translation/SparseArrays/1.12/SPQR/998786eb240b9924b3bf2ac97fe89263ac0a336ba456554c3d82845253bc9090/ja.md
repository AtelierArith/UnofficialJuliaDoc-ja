```julia
qr(A::SparseMatrixCSC; tol=_default_tol(A), ordering=ORDERING_DEFAULT) -> QRSparse
```

スパース行列 `A` の `QR` 因子分解を計算します。フィル削減行と列の置換が使用され、`F.R = F.Q'*A[F.prow,F.pcol]` となります。このタイプの主な用途は、[`\`](@ref) を使用して最小二乗または過剰決定問題を解決することです。この関数は C ライブラリ SPQR[^ACM933] を呼び出します。

!!! note
    `qr(A::SparseMatrixCSC)` は [SuiteSparse](https://github.com/DrTimothyAldenDavis/SuiteSparse) の一部である SPQR ライブラリを使用します。このライブラリは [`Float64`](@ref) または `ComplexF64` 要素を持つスパース行列のみをサポートしているため、Julia v1.4 以降、`qr` は `A` を `SparseMatrixCSC{Float64}` または `SparseMatrixCSC{ComplexF64}` 型のコピーに変換します。


# 例

```jldoctest
julia> A = sparse([1,2,3,4], [1,1,2,2], [1.0,1.0,1.0,1.0])
4×2 SparseMatrixCSC{Float64, Int64} with 4 stored entries:
 1.0   ⋅
 1.0   ⋅
  ⋅   1.0
  ⋅   1.0

julia> qr(A)
SparseArrays.SPQR.QRSparse{Float64, Int64}
Q 因子:
4×4 SparseArrays.SPQR.QRSparseQ{Float64, Int64}
R 因子:
2×2 SparseMatrixCSC{Float64, Int64} with 2 stored entries:
 -1.41421    ⋅
   ⋅       -1.41421
行の置換:
4-element Vector{Int64}:
 1
 3
 4
 2
列の置換:
2-element Vector{Int64}:
 1
 2
```

[^ACM933]: Foster, L. V., & Davis, T. A. (2013). Algorithm 933: Reliable Calculation of Numerical Rank, Null Space Bases, Pseudoinverse Solutions, and Basic Solutions Using SuitesparseQR. ACM Trans. Math. Softw., 40(1). [doi:10.1145/2513109.2513116](https://doi.org/10.1145/2513109.2513116)
