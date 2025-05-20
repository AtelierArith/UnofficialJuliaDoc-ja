```
rest(iter, state)
```

An iterator that yields the same elements as `iter`, but starting at the given `state`.

See also: [`Iterators.drop`](@ref), [`Iterators.peel`](@ref), [`Base.rest`](@ref).

# Examples

```jldoctest
julia> collect(Iterators.rest([1,2,3,4], 2))
3-element Vector{Int64}:
 2
 3
 4
```
