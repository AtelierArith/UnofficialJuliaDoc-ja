```julia
issorted(v, lt=isless, by=identity, rev::Bool=false, order::Base.Order.Ordering=Base.Order.Forward)
```

Test whether a collection is in sorted order. The keywords modify what order is considered sorted, as described in the [`sort!`](@ref) documentation.

# Examples

```jldoctest
julia> issorted([1, 2, 3])
true

julia> issorted([(1, "b"), (2, "a")], by = x -> x[1])
true

julia> issorted([(1, "b"), (2, "a")], by = x -> x[2])
false

julia> issorted([(1, "b"), (2, "a")], by = x -> x[2], rev=true)
true

julia> issorted([1, 2, -2, 3], by=abs)
true
```
