```julia
DateTime(d::Date, t::Time)
```

Construct a `DateTime` type by `Date` and `Time`. Non-zero microseconds or nanoseconds in the `Time` type will result in an `InexactError`.

!!! compat "Julia 1.1"
    This function requires at least Julia 1.1.


```jldoctest
julia> d = Date(2018, 1, 1)
2018-01-01

julia> t = Time(8, 15, 42)
08:15:42

julia> DateTime(d, t)
2018-01-01T08:15:42
```
