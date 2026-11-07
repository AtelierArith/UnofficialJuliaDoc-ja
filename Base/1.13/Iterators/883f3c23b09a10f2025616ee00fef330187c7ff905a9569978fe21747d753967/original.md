```julia
nth(itr, n::Integer)
```

Get the `n`th element of an iterable collection. Throw a `BoundsError`[@ref] if not existing. Will advance any `Stateful`[@ref] iterator.

See also: [`first`](@ref), [`last`](@ref)

# Examples

```jldoctest
julia> Iterators.nth(2:2:10, 4)
8

julia> Iterators.nth(reshape(1:30, (5,6)), 6)
6

julia> stateful = Iterators.Stateful(1:10); Iterators.nth(stateful, 7)
7

julia> first(stateful)
8
```

!!! compat "Julia 1.13"
    This function requires at least Julia 1.13.

