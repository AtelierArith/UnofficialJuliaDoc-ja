```
getrs!(trans, A, ipiv, B)
```

線形方程式 `A * X = B`、`transpose(A) * X = B`、または `adjoint(A) * X = B` を正方行列 `A` に対して解きます。解を持つ行列/ベクトル `B` をその場で修正します。`A` は `getrf!` からの `LU` 因子分解で、`ipiv` はピボット情報です。`trans` は `N`（変更なし）、`T`（転置）、または `C`（共役転置）のいずれかです。
