```
Slices{P,SM,AX,S,N} <: AbstractSlices{S,N}
```

An `AbstractArray` of slices into a parent array over specified dimension(s), returning views that select all the data from the other dimension(s).

These should typically be constructed by [`eachslice`](@ref), [`eachcol`](@ref) or [`eachrow`](@ref).

[`parent(s::Slices)`](@ref) will return the parent array.
