```
svd(A; full::Bool = false, alg::Algorithm = default_svd_alg(A)) -> SVD
```

行列 `A` の特異値分解 (SVD) を計算し、`SVD` オブジェクトを返します。

因子分解 `F` から `U`、`S`、`V` および `Vt` を取得することができ、`F.U`、`F.S`、`F.V` および `F.Vt` を使用します。これにより、`A = U * Diagonal(S) * Vt` となります。アルゴリズムは `Vt` を生成するため、`Vt` を抽出する方が `V` よりも効率的です。`S` の特異値は降順にソートされています。

分解を繰り返すことで、成分 `U`、`S`、および `V` を得ることができます。

`full = false`（デフォルト）の場合、"薄い" SVD が返されます。$M \times N$ 行列 `A` の場合、完全な因子分解では `U` は $M \times M$ であり、`V` は $N \times N$ ですが、薄い因子分解では `U` は $M \times K$ であり、`V` は $N \times K$ です。ここで、$K = \min(M,N)$ は特異値の数です。

`alg = DivideAndConquer()` の場合、分割統治アルゴリズムが SVD の計算に使用されます。別の（通常は遅いがより正確な）オプションは `alg = QRIteration()` です。

!!! compat "Julia 1.3"
    `alg` キーワード引数は Julia 1.3 以降が必要です。


# 例

```jldoctest
julia> A = rand(4,3);

julia> F = svd(A); # 因子分解オブジェクトを保存

julia> A ≈ F.U * Diagonal(F.S) * F.Vt
true

julia> U, S, V = F; # 繰り返しによる分解

julia> A ≈ U * Diagonal(S) * V'
true

julia> Uonly, = svd(A); # U のみを保存

julia> Uonly == U
true
```
