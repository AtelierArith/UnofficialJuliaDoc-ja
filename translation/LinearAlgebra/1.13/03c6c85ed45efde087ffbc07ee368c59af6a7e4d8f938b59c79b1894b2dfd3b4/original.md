```julia
ldiv!(A::Tridiagonal, B::AbstractVecOrMat) -> B
```

Compute `A \ B` in-place by Gaussian elimination with partial pivoting and store the result in `B`, returning the result. In the process, the diagonals of `A` are overwritten as well.

!!! compat "Julia 1.11"
    `ldiv!` for `Tridiagonal` left-hand sides requires at least Julia 1.11.

