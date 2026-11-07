```julia
RowSlices{M,AX,S}
```

A special case of [`Slices`](@ref) that is a vector of row slices of a matrix, as constructed by [`eachrow`](@ref).

[`parent`](@ref) can be used to get the underlying matrix.
