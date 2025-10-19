```julia
svd(A; full::Bool = false, alg::Algorithm = default_svd_alg(A)) -> SVD
```

行列 `A` の特異値分解 (SVD) を計算し、`SVD` オブジェクトを返します。

因数分解 `F` から `U`、`S`、`V` および `Vt` は `F.U`、`F.S`、`F.V` および `F.Vt` を使用して取得でき、`A = U * Diagonal(S) * Vt` となります。このアルゴリズムは `Vt` を生成するため、`Vt` を抽出する方が `V` よりも効率的です。`S` の特異値は降順にソートされています。

分解を繰り返すことで、成分 `U`、`S`、および `V` を得ることができます。

`full = false`（デフォルト）の場合、"薄い" SVD が返されます。$M \times N$ 行列 `A` の場合、完全な因数分解では `U` は $M \times M$ であり、`V` は $N \times N$ ですが、薄い因数分解では `U` は $M \times K$ であり、`V` は $N \times K$ で、$K = \min(M,N)$ は特異値の数です。

`alg` は SVD に使用するアルゴリズムと LAPACK メソッドを指定します：

  * `alg = LinearAlgebra.DivideAndConquer()`（デフォルト）：`LAPACK.gesdd!` を呼び出します。
  * `alg = LinearAlgebra.QRIteration()`：`LAPACK.gesvd!` を呼び出します（通常は遅いですが、より正確です）。

!!! compat "Julia 1.3"
    `alg` キーワード引数は Julia 1.3 以降が必要です。


# 例

```jldoctest
julia> A = rand(4,3);

julia> F = svd(A); # 因数分解オブジェクトを保存

julia> A ≈ F.U * Diagonal(F.S) * F.Vt
true

julia> U, S, V = F; # 繰り返しによる分解

julia> A ≈ U * Diagonal(S) * V'
true

julia> Uonly, = svd(A); # U のみを保存

julia> Uonly == U
true
```
