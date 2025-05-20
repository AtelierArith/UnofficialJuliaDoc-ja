```
Time(t::AbstractString, df::DateFormat=ISOTimeFormat) -> Time
```

Construct a `Time` by parsing the `t` date time string following the pattern given in the [`DateFormat`](@ref) object, or dateformat"HH:MM:SS.s" if omitted.

Similar to `Time(::AbstractString, ::AbstractString)` but more efficient when repeatedly parsing similarly formatted time strings with a pre-created `DateFormat` object.
