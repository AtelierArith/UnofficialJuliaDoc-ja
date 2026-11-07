```julia
getrs!(trans, A, ipiv, B)
```

正方行列 `A` に対する線形方程式 `A * X = B`、`transpose(A) * X = B`、または `adjoint(A) * X = B` を解きます。解を行列またはベクトル `B` に上書きします。`A` は、`getrf!` の `LU` 分解であり、`ipiv` はピボット情報です。`trans` には、`N`（変更なし）、`T`（転置）、または `C`（共役転置）を指定できます。
