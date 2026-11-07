```julia
CartesianIndex(i, j, k...)   -> I
CartesianIndex((i, j, k...)) -> I
```

Create a multidimensional index `I`, which can be used for indexing a multidimensional array `A`.  In particular, `A[I]` is equivalent to `A[i,j,k...]`.  One can freely mix integer and `CartesianIndex` indices; for example, `A[Ipre, i, Ipost]` (where `Ipre` and `Ipost` are `CartesianIndex` indices and `i` is an `Int`) can be a useful expression when writing algorithms that work along a single dimension of an array of arbitrary dimensionality.

A `CartesianIndex` is sometimes produced by [`eachindex`](@ref), and always when iterating with an explicit [`CartesianIndices`](@ref).

An `I::CartesianIndex` is treated as a "scalar" (not a container) for `broadcast`.   In order to iterate over the components of a `CartesianIndex`, convert it to a tuple with `Tuple(I)`.

# Examples

```jldoctest
julia> A = reshape(Vector(1:16), (2, 2, 2, 2))
2×2×2×2 Array{Int64, 4}:
[:, :, 1, 1] =
 1  3
 2  4

[:, :, 2, 1] =
 5  7
 6  8

[:, :, 1, 2] =
  9  11
 10  12

[:, :, 2, 2] =
 13  15
 14  16

julia> A[CartesianIndex((1, 1, 1, 1))]
1

julia> A[CartesianIndex((1, 1, 1, 2))]
9

julia> A[CartesianIndex((1, 1, 2, 1))]
5
```

!!! compat "Julia 1.10"
    Using a `CartesianIndex` as a "scalar" for `broadcast` requires Julia 1.10; in previous releases, use `Ref(I)`.

