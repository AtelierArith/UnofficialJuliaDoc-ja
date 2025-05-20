```
Date(d::AbstractString, df::DateFormat=ISODateFormat) -> Date
```

Construct a `Date` by parsing the `d` date string following the pattern given in the [`DateFormat`](@ref) object, or dateformat"yyyy-mm-dd" if omitted.

Similar to `Date(::AbstractString, ::AbstractString)` but more efficient when repeatedly parsing similarly formatted date strings with a pre-created `DateFormat` object.
