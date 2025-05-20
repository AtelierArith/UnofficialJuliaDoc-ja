```
tail(x::Tuple)::Tuple
```

Return a `Tuple` consisting of all but the first component of `x`.

See also: [`front`](@ref Base.front), [`rest`](@ref Base.rest), [`first`](@ref), [`Iterators.peel`](@ref).

# Examples

```jldoctest
julia> Base.tail((1,2,3))
(2, 3)

julia> Base.tail(())
ERROR: ArgumentError: Cannot call tail on an empty tuple.
```
