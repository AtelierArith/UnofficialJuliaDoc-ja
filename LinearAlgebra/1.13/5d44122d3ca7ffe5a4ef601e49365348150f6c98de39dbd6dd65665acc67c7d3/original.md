```julia
cis(A::AbstractMatrix)
```

More efficient method for `exp(im*A)` of square matrix `A` (especially if `A` is `Hermitian` or real-`Symmetric`).

See also [`cispi`](@ref), [`sincos`](@ref), [`exp`](@ref).

!!! compat "Julia 1.7"
    Support for using `cis` with matrices was added in Julia 1.7.


# Examples

```jldoctest
julia> cis([π 0; 0 π]) ≈ -I
true
```
