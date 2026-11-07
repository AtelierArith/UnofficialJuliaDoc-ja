```julia
rest(iter, state)
```

An iterator that yields the same elements as `iter`, but starting at the given `state`, which must be a state obtainable via a sequence of one or more calls to `iterate(iter[, state])`

See also: [`Iterators.drop`](@ref), [`Iterators.peel`](@ref), [`Base.rest`](@ref).

# Examples

```jldoctest
julia> iter = [1,2,3,4];

julia> val, state = iterate(iter)
(1, 2)

julia> collect(Iterators.rest(iter, state))
3-element Vector{Int64}:
 2
 3
 4
```
