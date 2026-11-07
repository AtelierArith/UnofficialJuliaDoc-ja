```julia
AbstractDict{K, V}
```

Supertype for dictionary-like types with keys of type `K` and values of type `V`. [`Dict`](@ref), [`IdDict`](@ref) and other types are subtypes of this. An `AbstractDict{K, V}` should be an iterator of `Pair{K, V}`.
