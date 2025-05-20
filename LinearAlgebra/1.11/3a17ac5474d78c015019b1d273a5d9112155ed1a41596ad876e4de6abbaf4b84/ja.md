```
Symmetric(A::AbstractMatrix, uplo::Symbol=:U)
```

行列 `A` の上三角（`uplo = :U` の場合）または下三角（`uplo = :L` の場合）の `Symmetric` ビューを構築します。

`Symmetric` ビューは主に実対称行列に対して有用であり、特化したアルゴリズム（例えば固有値問題用）が `Symmetric` 型に対して有効になります。より一般的には、実行列に対しては `Symmetric` と実質的に同等ですが、複素行列にも有用なエルミート行列 `A == A'` のために [`Hermitian(A)`](@ref) も参照してください。（複素 `Symmetric` 行列はサポートされていますが、特化したアルゴリズムはほとんどありません。）

実行列の対称部分、または一般的には実行列または複素行列 `A` のエルミート部分 `(A + A') / 2` を計算するには、[`hermitianpart`](@ref) を使用してください。

# 例

```jldoctest
julia> A = [1 2 3; 4 5 6; 7 8 9]
3×3 Matrix{Int64}:
 1  2  3
 4  5  6
 7  8  9

julia> Supper = Symmetric(A)
3×3 Symmetric{Int64, Matrix{Int64}}:
 1  2  3
 2  5  6
 3  6  9

julia> Slower = Symmetric(A, :L)
3×3 Symmetric{Int64, Matrix{Int64}}:
 1  4  7
 4  5  8
 7  8  9

julia> hermitianpart(A)
3×3 Hermitian{Float64, Matrix{Float64}}:
 1.0  3.0  5.0
 3.0  5.0  7.0
 5.0  7.0  9.0
```

`Supper` は `A` 自体が対称でない限り（例えば `A == transpose(A)` の場合） `Slower` と等しくなりません。
