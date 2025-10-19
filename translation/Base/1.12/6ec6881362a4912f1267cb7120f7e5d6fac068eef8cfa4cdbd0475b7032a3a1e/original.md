```julia
tryparse(type, str; base)
```

Like [`parse`](@ref), but returns either a value of the requested type, or [`nothing`](@ref) if the string does not contain a valid number.
