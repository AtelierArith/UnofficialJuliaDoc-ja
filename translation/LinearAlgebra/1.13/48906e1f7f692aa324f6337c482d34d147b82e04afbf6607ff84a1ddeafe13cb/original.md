```julia
default_eigen_alg(A)
```

Return the default algorithm used to solve the eigensystem `A v = λ v` for a symmetric matrix `A`. Defaults to `LinearAlegbra.RobustRepresentations()`, which corresponds to the LAPACK function `LAPACK.syevr!`.
