```julia
ColumnSlices{M,AX,S}
```

A special case of [`Slices`](@ref) that is a vector of column slices of a matrix, as constructed by [`eachcol`](@ref).

[`parent`](@ref) can be used to get the underlying matrix.
