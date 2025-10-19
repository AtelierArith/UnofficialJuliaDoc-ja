```julia
AbstractSlices{S,N} <: AbstractArray{S,N}
```

Supertype for arrays of slices into a parent array over some dimension(s), returning views that select all the data from the other dimensions.

`parent` will return the parent array.
