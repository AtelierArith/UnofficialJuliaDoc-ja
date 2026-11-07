```julia
qr(A::SparseMatrixCSC; tol=_default_tol(A), ordering=ORDERING_DEFAULT) -> QRSparse
```

疎行列 `A` の `QR` 分解を計算します。フィルインを抑えるため、行と列の置換を用いて `F.R = F.Q'*A[F.prow,F.pcol]` とします。この種の分解は、[`\`](@ref) を用いて最小二乗問題や劣決定問題を解く際に主に利用されます。この関数は C ライブラリ SPQR[^ACM933] を呼び出します。

!!! note
    返される `QRSparse` オブジェクトは、[`ldiv!()`](@ref) 呼び出し用の内部ワークスペースを使用します。このワークスペースはスレッドセーフのためロックで保護されています。マルチスレッドで使用する場合は、各タスク用に `copy(F)` でこのオブジェクトのコピーを個別に作成してください。


!!! note
    `qr(A::SparseMatrixCSC)` は、[SuiteSparse](https://github.com/DrTimothyAldenDavis/SuiteSparse) に含まれる SPQR ライブラリを使用します。このライブラリがサポートする疎行列の要素型は [`Float64`](@ref) または `ComplexF64` のみです。そのため Julia v1.4 以降では、`qr` は `A` を、適切な型である `SparseMatrixCSC{Float64}` または `SparseMatrixCSC{ComplexF64}` のコピーに変換します。


# Examples

```jldoctest
julia> A = sparse([1,2,3,4], [1,1,2,2], [1.0,1.0,1.0,1.0])
4×2 SparseMatrixCSC{Float64, Int64} with 4 stored entries:
 1.0   ⋅
 1.0   ⋅
  ⋅   1.0
  ⋅   1.0

julia> qr(A)
SparseArrays.SPQR.QRSparse{Float64, Int64}
Q factor:
4×4 SparseArrays.SPQR.QRSparseQ{Float64, Int64}
R factor:
2×2 SparseMatrixCSC{Float64, Int64} with 2 stored entries:
 -1.41421    ⋅
   ⋅       -1.41421
Row permutation:
4-element Vector{Int64}:
 1
 3
 4
 2
Column permutation:
2-element Vector{Int64}:
 1
 2
```

[^ACM933]: Foster, L. V., & Davis, T. A. (2013). Algorithm 933: Reliable Calculation of Numerical Rank, Null Space Bases, Pseudoinverse Solutions, and Basic Solutions Using SuitesparseQR. ACM Trans. Math. Softw., 40(1). [doi:10.1145/2513109.2513116](https://doi.org/10.1145/2513109.2513116)
