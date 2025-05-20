```
Time(t::AbstractString, format::AbstractString; locale="english") -> Time
```

Construct a `Time` by parsing the `t` time string following the pattern given in the `format` string (see [`DateFormat`](@ref) for syntax).

!!! note
    This method creates a `DateFormat` object each time it is called. It is recommended that you create a [`DateFormat`](@ref) object instead and use that as the second argument to avoid performance loss when using the same format repeatedly.


# Examples

```jldoctest
julia> Time("12:34pm", "HH:MMp")
12:34:00

julia> a = ("12:34pm", "2:34am");

julia> [Time(d, dateformat"HH:MMp") for d ∈ a] # preferred
2-element Vector{Time}:
 12:34:00
 02:34:00
```
