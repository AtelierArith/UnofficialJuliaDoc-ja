```julia
front(x::Tuple)::Tuple
```

Return a `Tuple` consisting of all but the last component of `x`.

See also: [`first`](@ref), [`tail`](@ref Base.tail).

# Examples

```jldoctest
julia> Base.front((1,2,3))
(1, 2)

julia> Base.front(())
ERROR: ArgumentError: Cannot call front on an empty tuple.
```
