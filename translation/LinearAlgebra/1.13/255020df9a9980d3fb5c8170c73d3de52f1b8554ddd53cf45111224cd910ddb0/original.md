```julia
mul!(C::AbstractVecOrMat, tA, tB, A::AbstractVecOrMat, B::AbstractVecOrMat, α::Number, β::Number)
```

Calculates the combined matrix-matrix multiply-add ``A B α + C β`` (`tA == 'N'`), ``A^⊤ B α + C β`` (`tA == 'T'`), or ``A' B α + C β`` (`tA == 'C'`), with potential matrix transpositions of `B` corresponding to `tB`. The result is stored in `C` by overwriting it.  Note that `C` must not be aliased with either `A` or `B`.

This is an abstraction layer below 5-arg [`mul!`](@ref). Packages that provide their own storage type are advised to overload this method instead of 5-arg `mul!`.

!!! compat "Julia 1.13"
    This method requires at least Julia 1.13 and supersedes the non-public `generic_matmatmul!` method with the same signature.

