```
Broadcast.broadcastable(x)
```

Return either `x` or an object like `x` such that it supports [`axes`](@ref), indexing, and its type supports [`ndims`](@ref).

If `x` supports iteration, the returned value should have the same `axes` and indexing behaviors as [`collect(x)`](@ref).

If `x` is not an `AbstractArray` but it supports `axes`, indexing, and its type supports `ndims`, then `broadcastable(::typeof(x))` may be implemented to just return itself. Further, if `x` defines its own [`BroadcastStyle`](@ref), then it must define its `broadcastable` method to return itself for the custom style to have any effect.

# Examples

```jldoctest
julia> Broadcast.broadcastable([1,2,3]) # like `identity` since arrays already support axes and indexing
3-element Vector{Int64}:
 1
 2
 3

julia> Broadcast.broadcastable(Int) # Types don't support axes, indexing, or iteration but are commonly used as scalars
Base.RefValue{Type{Int64}}(Int64)

julia> Broadcast.broadcastable("hello") # Strings break convention of matching iteration and act like a scalar instead
Base.RefValue{String}("hello")
```
