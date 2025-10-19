```julia
cholesky(A::SparseMatrixCSC; shift = 0.0, check = true, perm = nothing) -> CHOLMOD.Factor
```

スパースの正定値行列 `A` のコレスキー分解を計算します。`A` は [`SparseMatrixCSC`](@ref) であるか、`SparseMatrixCSC` の [`Symmetric`](@ref)/[`Hermitian`](@ref) ビューでなければなりません。`A` に型タグがなくても、対称またはエルミートである必要があります。`perm` が指定されていない場合、フィル削減置換が使用されます。`F = cholesky(A)` は、`F\b` を使用して方程式系を解くために最も頻繁に使用されますが、[`diag`](@ref)、[`det`](@ref)、および [`logdet`](@ref) のメソッドも `F` に対して定義されています。また、`F` から個々の因子を `F.L` を使用して抽出することもできます。ただし、ピボッティングがデフォルトでオンになっているため、分解は内部的に `A == P'*L*L'*P` として表現され、置換行列 `P` が含まれています。`P` を考慮せずに `L` のみを使用すると、誤った結果が得られます。置換の効果を含めるには、通常、`PtL = F.PtL`（`P'*L` の同等物）や `LtP = F.UP`（`L'*P` の同等物）などの「結合」因子を抽出する方が好ましいです。

`check = true` の場合、分解が失敗した場合にエラーがスローされます。`check = false` の場合、分解の有効性を確認する責任（[`issuccess`](@ref) を介して）はユーザーにあります。

オプションの `shift` キーワード引数を設定すると、`A` の代わりに `A+shift*I` の分解が計算されます。`perm` 引数が提供される場合、それは `1:size(A,1)` の置換であり、使用する順序を指定します（CHOLMOD のデフォルトの AMD 順序の代わりに）。

正定値性を必要としない類似の分解については、[`ldlt`](@ref) を参照してください。ただし、`cholesky` よりもかなり遅くなる可能性があります。

# 例

次の例では、使用されるフィル削減置換は `[3, 2, 1]` です。`perm` が `1:3` に設定されて置換が行われない場合、因子内の非ゼロ要素の数は 6 になります。

```jldoctest
julia> A = [2 1 1; 1 2 0; 1 0 2]
3×3 Matrix{Int64}:
 2  1  1
 1  2  0
 1  0  2

julia> C = cholesky(sparse(A))
SparseArrays.CHOLMOD.Factor{Float64, Int64}
type:    LLt
method:  simplicial
maxnnz:  5
nnz:     5
success: true

julia> C.p
3-element Vector{Int64}:
 3
 2
 1

julia> L = sparse(C.L);

julia> Matrix(L)
3×3 Matrix{Float64}:
 1.41421   0.0       0.0
 0.0       1.41421   0.0
 0.707107  0.707107  1.0

julia> L * L' ≈ A[C.p, C.p]
true

julia> P = sparse(1:3, C.p, ones(3))
3×3 SparseMatrixCSC{Float64, Int64} with 3 stored entries:
  ⋅    ⋅   1.0
  ⋅   1.0   ⋅
 1.0   ⋅    ⋅

julia> P' * L * L' * P ≈ A
true

julia> C = cholesky(sparse(A), perm=1:3)
SparseArrays.CHOLMOD.Factor{Float64, Int64}
type:    LLt
method:  simplicial
maxnnz:  6
nnz:     6
success: true

julia> L = sparse(C.L);

julia> Matrix(L)
3×3 Matrix{Float64}:
 1.41421    0.0       0.0
 0.707107   1.22474   0.0
 0.707107  -0.408248  1.1547

julia> L * L' ≈ A
true
```

!!! note
    このメソッドは、[SuiteSparse](https://github.com/DrTimothyAldenDavis/SuiteSparse) の CHOLMOD[^ACM887][^DavisHager2009] ライブラリを使用しています。CHOLMOD は、単精度または倍精度の実数または複素数型のみをサポートしています。これらの要素型でない入力行列は、適切にこれらの型に変換されます。

    CHOLMOD からの他の多くの関数はラップされていますが、`Base.SparseArrays.CHOLMOD` モジュールからはエクスポートされていません。


[^ACM887]: Chen, Y., Davis, T. A., Hager, W. W., & Rajamanickam, S. (2008). Algorithm 887: CHOLMOD, Supernodal Sparse Cholesky Factorization and Update/Downdate. ACM Trans. Math. Softw., 35(3). [doi:10.1145/1391989.1391995](https://doi.org/10.1145/1391989.1391995)

[^DavisHager2009]: Davis, Timothy A., & Hager, W. W. (2009). Dynamic Supernodes in Sparse Cholesky Update/Downdate and Triangular Solves. ACM Trans. Math. Softw., 35(4). [doi:10.1145/1462173.1462176](https://doi.org/10.1145/1462173.1462176)
