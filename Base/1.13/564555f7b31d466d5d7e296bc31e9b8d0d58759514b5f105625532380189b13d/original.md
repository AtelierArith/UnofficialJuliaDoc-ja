```julia
structdiff(a::NamedTuple, b::Union{NamedTuple,Type{NamedTuple}})
```

Construct a copy of named tuple `a`, except with fields that exist in `b` removed. `b` can be a named tuple, or a type of the form `NamedTuple{field_names}`.
