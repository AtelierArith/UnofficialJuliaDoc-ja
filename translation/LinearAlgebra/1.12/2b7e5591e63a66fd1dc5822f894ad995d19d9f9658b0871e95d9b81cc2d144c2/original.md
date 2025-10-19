```julia
rank(A::QRPivoted{<:Any, T}; atol::Real=0, rtol::Real=min(n,m)*ϵ) where {T}
```

Compute the numerical rank of the QR factorization `A` by counting how many diagonal entries of `A.factors` are greater than `max(atol, rtol*Δ₁)` where `Δ₁` is the largest calculated such entry. This is similar to the [`rank(::AbstractMatrix)`](@ref) method insofar as it counts the number of (numerically) nonzero coefficients from a matrix factorization, although the default method uses an SVD instead of a QR factorization. Like [`rank(::SVD)`](@ref), this method also re-uses an existing matrix factorization.

Using a QR factorization to compute rank should typically produce the same result as using SVD, although it may be more prone to overestimating the rank in pathological cases where the matrix is ill-conditioned. It is also worth noting that it is generally faster to compute a QR factorization than it is to compute an SVD, so this method may be preferred when performance is a concern.

`atol` and `rtol` are the absolute and relative tolerances, respectively. The default relative tolerance is `n*ϵ`, where `n` is the size of the smallest dimension of `A` and `ϵ` is the [`eps`](@ref) of the element type of `A`.

!!! compat "Julia 1.12"
    The `rank(::QRPivoted)` method requires at least Julia 1.12.

