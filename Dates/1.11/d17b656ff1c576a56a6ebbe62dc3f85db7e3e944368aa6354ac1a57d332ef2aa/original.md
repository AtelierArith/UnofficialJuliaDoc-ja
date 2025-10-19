```julia
Date(d::AbstractString, format::AbstractString; locale="english") -> Date
```

Construct a `Date` by parsing the `d` date string following the pattern given in the `format` string (see [`DateFormat`](@ref) for syntax).

!!! note
    This method creates a `DateFormat` object each time it is called. It is recommended that you create a [`DateFormat`](@ref) object instead and use that as the second argument to avoid performance loss when using the same format repeatedly.


# Examples

```jldoctest
julia> Date("2020-01-01", "yyyy-mm-dd")
2020-01-01

julia> a = ("2020-01-01", "2020-01-02");

julia> [Date(d, dateformat"yyyy-mm-dd") for d ∈ a] # preferred
2-element Vector{Date}:
 2020-01-01
 2020-01-02
```
