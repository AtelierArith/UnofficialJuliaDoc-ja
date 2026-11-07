```julia
ggsvd3!(jobu, jobv, jobq, A, B) -> (U, V, Q, alpha, beta, k, l, R)
```

`A` と `B`、および `U'*A*Q = D1*R` と `V'*B*Q = D2*R` の一般化特異値分解を求めます。`D1` の対角成分は `alpha`、`D2` の対角成分は `beta` です。`jobu = U` の場合、直交／ユニタリ行列 `U` を計算します。`jobv = V` の場合、直交／ユニタリ行列 `V` を計算します。`jobq = Q` の場合、直交／ユニタリ行列 `Q` を計算します。`jobu`、`jobv`、または `jobq` が `N` の場合、その行列は計算されません。この関数には LAPACK 3.6.0 が必要です。
