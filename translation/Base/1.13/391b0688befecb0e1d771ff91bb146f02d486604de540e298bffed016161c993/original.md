```julia
IndexStyle(A)
IndexStyle(typeof(A))
```

`IndexStyle` specifies the "native indexing style" for array `A`. When you define a new [`AbstractArray`](@ref) type, you can choose to implement either linear indexing (with [`IndexLinear`](@ref)) or cartesian indexing. If you decide to only implement linear indexing, then you must set this trait for your array type:

```julia
Base.IndexStyle(::Type{<:MyArray}) = IndexLinear()
```

The default is [`IndexCartesian()`](@ref).

Julia's internal indexing machinery will automatically (and invisibly) recompute all indexing operations into the preferred style. This allows users to access elements of your array using any indexing style, even when explicit methods have not been provided.

If you define both styles of indexing for your `AbstractArray`, this trait can be used to select the most performant indexing style. Some methods check this trait on their inputs, and dispatch to different algorithms depending on the most efficient access pattern. In particular, [`eachindex`](@ref) creates an iterator whose type depends on the setting of this trait.
