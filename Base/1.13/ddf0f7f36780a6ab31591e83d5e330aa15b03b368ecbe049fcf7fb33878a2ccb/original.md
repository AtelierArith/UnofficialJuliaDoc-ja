```julia
copy(x)
```

Create a shallow copy of `x`: the outer structure is copied, but not all internal values. For example, copying an array produces a new array with identically-same elements as the original.

See also [`copy!`](@ref Base.copy!), [`copyto!`](@ref), [`deepcopy`](@ref).
