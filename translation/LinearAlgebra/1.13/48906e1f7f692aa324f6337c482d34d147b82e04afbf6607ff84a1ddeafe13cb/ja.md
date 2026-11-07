```julia
default_eigen_alg(A)
```

対称行列 `A` の固有系 `A v = λ v` を解く際に使用されるデフォルトのアルゴリズムを返します。デフォルトは `LinearAlegbra.RobustRepresentations()` で、LAPACK 関数 `LAPACK.syevr!` に対応します。
