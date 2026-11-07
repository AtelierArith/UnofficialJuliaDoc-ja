```julia
ggsvd!(jobu, jobv, jobq, A, B) -> (U, V, Q, alpha, beta, k, l, R)
```

`A` と `B`、`U'*A*Q = D1*R`、`V'*B*Q = D2*R` の一般化特異値分解を求めます。`D1` の対角成分は `alpha`、`D2` の対角成分は `beta` です。`jobu = U` の場合、直交／ユニタリ行列 `U` が計算されます。`jobv = V` の場合、直交／ユニタリ行列 `V` が計算されます。`jobq = Q` の場合、直交／ユニタリ行列 `Q` が計算されます。`jobu`、`jobv`、または `jobq` が `N` の場合、その行列は計算されません。この関数は LAPACK 3.6.0 より前のバージョンでのみ利用できます。
