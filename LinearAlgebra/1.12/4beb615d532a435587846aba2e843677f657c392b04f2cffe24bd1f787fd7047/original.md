```julia
eigen(A::Union{Hermitian, Symmetric}; alg::LinearAlgebra.Algorithm = LinearAlgebra.default_eigen_alg(A)) -> Eigen
```

Compute the eigenvalue decomposition of `A`, returning an [`Eigen`](@ref) factorization object `F` which contains the eigenvalues in `F.values` and the orthonormal eigenvectors in the columns of the matrix `F.vectors`. (The `k`th eigenvector can be obtained from the slice `F.vectors[:, k]`.)

Iterating the decomposition produces the components `F.values` and `F.vectors`.

`alg` specifies which algorithm and LAPACK method to use for eigenvalue decomposition:

  * `alg = DivideAndConquer()`: Calls `LAPACK.syevd!`.
  * `alg = QRIteration()`: Calls `LAPACK.syev!`.
  * `alg = RobustRepresentations()` (default): Multiple relatively robust representations method, Calls `LAPACK.syevr!`.

See James W. Demmel et al, SIAM J. Sci. Comput. 30, 3, 1508 (2008) for a comparison of the accuracy and performance of different algorithms.

The default `alg` used may change in the future.

!!! compat "Julia 1.12"
    The `alg` keyword argument requires Julia 1.12 or later.


The following functions are available for `Eigen` objects: [`inv`](@ref), [`det`](@ref), and [`isposdef`](@ref).
