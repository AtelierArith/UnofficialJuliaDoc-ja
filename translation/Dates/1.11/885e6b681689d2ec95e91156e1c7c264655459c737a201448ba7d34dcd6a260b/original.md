```
DateTime(dt::AbstractString, df::DateFormat=ISODateTimeFormat) -> DateTime
```

Construct a `DateTime` by parsing the `dt` date time string following the pattern given in the [`DateFormat`](@ref) object, or dateformat"yyyy-mm-dd\THH:MM:SS.s" if omitted.

Similar to `DateTime(::AbstractString, ::AbstractString)` but more efficient when repeatedly parsing similarly formatted date time strings with a pre-created `DateFormat` object.
