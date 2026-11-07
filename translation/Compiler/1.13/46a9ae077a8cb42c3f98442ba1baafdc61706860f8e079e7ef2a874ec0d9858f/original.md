```julia
validate_code!(errors::Vector{InvalidCodeError}, mi::MethodInstance,
               c::Union{Nothing,CodeInfo})
```

Validate `mi`, logging any violation by pushing an `InvalidCodeError` into `errors`.

If `isa(c, CodeInfo)`, also call `validate_code!(errors, c)`. It is assumed that `c` is a `CodeInfo` instance associated with `mi`.
