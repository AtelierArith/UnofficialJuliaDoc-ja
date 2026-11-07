```julia
nth(n::Integer)
```

Return a function that gets the `n`-th element from any iterator passed to it. Equivalent to `Base.Fix2(nth, n)` or `itr -> nth(itr, n)`.

See also: [`nth`](@ref), [`Base.Fix2`](@ref)

# Examples

```jldoctest
julia> fifth_element = Iterators.nth(5)
(::Base.Fix2{typeof(Base.Iterators.nth), Int64}) (generic function with 2 methods)

julia> fifth_element(reshape(1:30, (5,6)))
5

julia> map(fifth_element, ("Willis", "Jovovich", "Oldman"))
('i', 'v', 'a')
```
