```julia
pinv(M; atol::Real=0, rtol::Real=atol>0 ? 0 : n*ϵ)
pinv(M, rtol::Real) = pinv(M; rtol=rtol) # to be deprecated in Julia 2.0
```

Computes the Moore-Penrose pseudoinverse.

For matrices `M` with floating point elements, it is convenient to compute the pseudoinverse by inverting only singular values greater than `max(atol, rtol*σ₁)` where `σ₁` is the largest singular value of `M`.

The optimal choice of absolute (`atol`) and relative tolerance (`rtol`) varies both with the value of `M` and the intended application of the pseudoinverse. The default relative tolerance is `n*ϵ`, where `n` is the size of the smallest dimension of `M`, and `ϵ` is the [`eps`](@ref) of the element type of `M`.

For solving dense, ill-conditioned equations in a least-square sense, it is better to *not* explicitly form the pseudoinverse matrix, since this can lead to numerical instability at low tolerances.  The default `M \ b` algorithm instead uses pivoted QR factorization ([`qr`](@ref)).  To use an SVD-based algorithm, it is better to employ the SVD directly via `svd(M; rtol, atol) \ b` or `ldiv!(svd(M), b; rtol, atol)`.

One can also pass `M = svd(A)` as the argument to `pinv` in order to re-use an existing [`SVD`](@ref) factorization.  In this case, `pinv` will return the SVD of the pseudo-inverse, which can be applied accurately, instead of an explicit matrix.

!!! compat "Julia 1.13"
    Passing an `SVD` object to `pinv` requires Julia 1.13 or later.


For more information, see [^pr1387], [^B96], [^S84], [^KY88].

# Examples

```jldoctest
julia> M = [1.5 1.3; 1.2 1.9]
2×2 Matrix{Float64}:
 1.5  1.3
 1.2  1.9

julia> N = pinv(M)
2×2 Matrix{Float64}:
  1.47287   -1.00775
 -0.930233   1.16279

julia> M * N
2×2 Matrix{Float64}:
 1.0          -2.22045e-16
 4.44089e-16   1.0
```

[^pr1387]: PR 1387, "stable pinv least-squares", [LinearAlgebra.jl#1387](https://github.com/JuliaLang/LinearAlgebra.jl/pull/1387)

[^B96]: Åke Björck, "Numerical Methods for Least Squares Problems",  SIAM Press, Philadelphia, 1996, "Other Titles in Applied Mathematics", Vol. 51. [doi:10.1137/1.9781611971484](http://epubs.siam.org/doi/book/10.1137/1.9781611971484)

[^S84]: G. W. Stewart, "Rank Degeneracy", SIAM Journal on Scientific and Statistical Computing, 5(2), 1984, 403-413. [doi:10.1137/0905030](http://epubs.siam.org/doi/abs/10.1137/0905030)

[^KY88]: Konstantinos Konstantinides and Kung Yao, "Statistical analysis of effective singular values in matrix rank determination", IEEE Transactions on Acoustics, Speech and Signal Processing, 36(5), 1988, 757-763. [doi:10.1109/29.1585](https://doi.org/10.1109/29.1585)
