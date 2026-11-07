```julia
ldiv!(F::SVD, B; atol::Real=0, rtol::Real=atol>0 ? 0 : n*ϵ)
```

Given the SVD `F` of an ``m \times n`` matrix, multiply the first ``m`` rows of `B` in-place by the Moore-Penrose pseudoinverse, storing the result in the first ``n`` rows of `B`, returning `B`. This is equivalent to a least-squares solution (for ``m \ge n``) or a minimum-norm solution (for ``m \le n``).

Similar to the [`pinv`](@ref) function, the solution can be regularized by truncating the SVD, dropping any singular values less than `max(atol, rtol*σ₁)` where `σ₁` is the largest singular value. The default relative tolerance is `n*ϵ`, where `n` is the size of the smallest dimension of `M`, and `ϵ` is the [`eps`](@ref) of the element type of `M`.

!!! compat "Julia 1.13"
    The `atol` and `rtol` arguments require Julia 1.13 or later.

