```julia
mul!(c::AbstractVector, tA, A::AbstractVecOrMat, b::AbstractVector, α::Number, β::Number)
```

Calculates the combined matrix-vector multiply-add ``A b α + c β`` (`tA == 'N'`), ``A^⊤ b α + c β`` (`tA == 'T'`), or ``A' b α + c β`` (`tA == 'C'`). The result is stored in `c` by overwriting it.  Note that `c` must not be aliased with either `A` or `b`.

This is an abstraction layer below 5-arg [`mul!`](@ref) used to dispatch on storage types. Packages that provide their own storage type are advised to overload this method signature instead of 5-arg `mul!`.

!!! compat "Julia 1.13"
    This method requires at least Julia 1.13 and supersedes the non-public `generic_matvecmul!` method with the same signature.

