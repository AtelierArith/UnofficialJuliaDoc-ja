```julia
eigvals(A::Union{Hermitian, Symmetric}; alg::Algorithm = default_eigen_alg(A))) -> values
```

Return the eigenvalues of `A`.

`alg` specifies which algorithm and LAPACK method to use for eigenvalue decomposition:

  * `alg = DivideAndConquer()`: Calls `LAPACK.syevd!`.
  * `alg = QRIteration()`: Calls `LAPACK.syev!`.
  * `alg = RobustRepresentations()` (default): Multiple relatively robust representations method, Calls `LAPACK.syevr!`.

See James W. Demmel et al, SIAM J. Sci. Comput. 30, 3, 1508 (2008) for a comparison of the accuracy and performance of different methods.

The default `alg` used may change in the future.

!!! compat "Julia 1.12"
    The `alg` keyword argument requires Julia 1.12 or later.

