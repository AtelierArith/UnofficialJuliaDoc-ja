```julia
CartesianIndices(sz::Dims) -> R
CartesianIndices((istart:[istep:]istop, jstart:[jstep:]jstop, ...)) -> R
```

Define a region `R` spanning a multidimensional rectangular range of integer indices. These are most commonly encountered in the context of iteration, where `for I in R ... end` will return [`CartesianIndex`](@ref) indices `I` equivalent to the nested loops

```julia
for j = jstart:jstep:jstop
    for i = istart:istep:istop
        ...
    end
end
```

Consequently these can be useful for writing algorithms that work in arbitrary dimensions.

```julia
CartesianIndices(A::AbstractArray) -> R
```

As a convenience, constructing a `CartesianIndices` from an array makes a range of its indices.

!!! compat "Julia 1.6"
    The step range method `CartesianIndices((istart:istep:istop, jstart:[jstep:]jstop, ...))` requires at least Julia 1.6.


# Examples

```jldoctest
julia> foreach(println, CartesianIndices((2, 2, 2)))
CartesianIndex(1, 1, 1)
CartesianIndex(2, 1, 1)
CartesianIndex(1, 2, 1)
CartesianIndex(2, 2, 1)
CartesianIndex(1, 1, 2)
CartesianIndex(2, 1, 2)
CartesianIndex(1, 2, 2)
CartesianIndex(2, 2, 2)

julia> CartesianIndices(fill(1, (2,3)))
CartesianIndices((2, 3))
```

## Conversion between linear and cartesian indices

Linear index to cartesian index conversion exploits the fact that a `CartesianIndices` is an `AbstractArray` and can be indexed linearly:

```jldoctest
julia> cartesian = CartesianIndices((1:3, 1:2))
CartesianIndices((1:3, 1:2))

julia> cartesian[4]
CartesianIndex(1, 2)

julia> cartesian = CartesianIndices((1:2:5, 1:2))
CartesianIndices((1:2:5, 1:2))

julia> cartesian[2, 2]
CartesianIndex(3, 2)
```

## Broadcasting

`CartesianIndices` support broadcasting arithmetic (+ and -) with a `CartesianIndex`.

!!! compat "Julia 1.1"
    Broadcasting of CartesianIndices requires at least Julia 1.1.


```jldoctest
julia> CIs = CartesianIndices((2:3, 5:6))
CartesianIndices((2:3, 5:6))

julia> CI = CartesianIndex(3, 4)
CartesianIndex(3, 4)

julia> CIs .+ CI
CartesianIndices((5:6, 9:10))
```

For cartesian to linear index conversion, see [`LinearIndices`](@ref).
