```julia
oneunit(x::T)
oneunit(T::Type)
```

Return `T(one(x))`, where `T` is either the type of the argument, or the argument itself in cases where the `oneunit` can be deduced from the type alone. This differs from [`one`](@ref) for dimensionful quantities: `one` is dimensionless (a multiplicative identity) while `oneunit` is dimensionful (of the same type as `x`, or of type `T`).

# Examples

```jldoctest
julia> oneunit(3.7)
1.0

julia> import Dates; oneunit(Dates.Day)
1 day
```
