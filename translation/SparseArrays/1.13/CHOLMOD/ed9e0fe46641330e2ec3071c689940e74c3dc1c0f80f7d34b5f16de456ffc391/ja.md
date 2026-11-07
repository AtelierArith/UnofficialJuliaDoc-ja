```julia
cholesky(A::SparseMatrixCSC; shift = 0.0, check = true, perm = nothing) -> CHOLMOD.Factor
```

疎な正定値行列 `A` のコレスキー分解を計算します。`A` は、`SparseMatrixCSC` の [`SparseMatrixCSC`](@ref) または [`Symmetric`](@ref)/[`Hermitian`](@ref) ビューである必要があります。`A` に型タグが付いていない場合は、それ自体が対称行列またはエルミート行列でなければならない点に注意してください。`perm` を指定しない場合、フィルインを減らす置換が使用されます。`F = cholesky(A)` は、`F\b` を用いた連立方程式の求解に最もよく使われますが、`F` に対しては、[`diag`](@ref)、[`det`](@ref)、[`logdet`](@ref) の各メソッドも定義されています。`F` から、`F.L` を使って個々の因子を取り出すこともできます。ただし、既定ではピボット選択が有効なため、分解結果は内部的に置換行列 `P` を伴う `A == P'*L*L'*P` として表現されます。`P` を考慮せずに `L` だけを使うと、誤った結果になります。置換の影響を反映するには、通常、`PtL = F.PtL`（`P'*L` に相当）や `LtP = F.UP`（`L'*P` に相当）のような「結合」因子を取り出すのが適切です。サポートされている因子の一覧は `:L, :PtL, :UP, :U` です。置換ベクトルは `F.p` で取得でき、次のように定義されています。`L*L' == A[p, p]`、

`L` 成分は、`sparse(F.L)` を使って疎行列として実体化できます。その他の成分は直接実体化できませんが、必要に応じて `sparse(F.L)` と `F.p` から再構成できます。

`check = true` の場合、分解に失敗するとエラーがスローされます。`check = false` の場合、[`issuccess`](@ref) による分解の妥当性確認はユーザーの責任となります。

省略可能なキーワード引数 `shift` を設定すると、`A` ではなく `A+shift*I` の分解を計算します。`perm` 引数を指定する場合は、使用する順序を表す `1:size(A,1)` の置換である必要があります（CHOLMOD の既定の AMD 順序付けの代わりに使用されます）。

正定値性を必要としない類似の分解については [`ldlt`](@ref) も参照してください。ただし、`cholesky` より大幅に遅くなる場合があります。

# Examples

次の例では、フィルインを減らすために `[3, 2, 1]` が使用されています。置換を行わないように `perm` を `1:3` に設定すると、因子の非ゼロ要素数は 6 になります。

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
    このメソッドは、[SuiteSparse](https://github.com/DrTimothyAldenDavis/SuiteSparse) の CHOLMOD[^ACM887][^DavisHager2009] ライブラリを使用します。CHOLMOD がサポートするのは、単精度または倍精度の実数型および複素数型のみです。これら以外の要素型を持つ入力行列は、適切な型に変換されます。

    CHOLMOD のその他の多くの関数もラップされていますが、`Base.SparseArrays.CHOLMOD` モジュールからはエクスポートされていません。


[^ACM887]: Chen, Y., Davis, T. A., Hager, W. W., & Rajamanickam, S. (2008). Algorithm 887: CHOLMOD, Supernodal Sparse Cholesky Factorization and Update/Downdate. ACM Trans. Math. Softw., 35(3). [doi:10.1145/1391989.1391995](https://doi.org/10.1145/1391989.1391995)

[^DavisHager2009]: Davis, Timothy A., & Hager, W. W. (2009). Dynamic Supernodes in Sparse Cholesky Update/Downdate and Triangular Solves. ACM Trans. Math. Softw., 35(4). [doi:10.1145/1462173.1462176](https://doi.org/10.1145/1462173.1462176)
