```julia
rank(S::SVD{<:Any, T}; atol::Real=0, rtol::Real=min(n,m)*ϵ) where {T}
```

Compute the numerical rank of the SVD object `S` by counting how many singular values are greater  than `max(atol, rtol*σ₁)` where `σ₁` is the largest calculated singular value. This is equivalent to the default [`rank(::AbstractMatrix)`](@ref) method except that it re-uses an existing SVD factorization. `atol` and `rtol` are the absolute and relative tolerances, respectively. The default relative tolerance is `n*ϵ`, where `n` is the size of the smallest dimension of UΣV' and `ϵ` is the [`eps`](@ref) of the element type of `S`.

!!! compat "Julia 1.12"
    The `rank(::SVD)` method requires at least Julia 1.12.

