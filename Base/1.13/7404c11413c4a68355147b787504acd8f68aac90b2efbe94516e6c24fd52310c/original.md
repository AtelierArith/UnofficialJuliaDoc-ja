```julia
SubArray{T,N,P,I,L} <: AbstractArray{T,N}
```

`N`-dimensional view into a parent array (of type `P`) with an element type `T`, restricted by a tuple of indices (of type `I`). `L` is true for types that support fast linear indexing, and `false` otherwise.

Construct `SubArray`s using the [`view`](@ref) function.
