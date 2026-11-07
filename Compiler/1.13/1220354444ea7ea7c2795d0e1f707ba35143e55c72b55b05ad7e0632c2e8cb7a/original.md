```julia
validate_code!(errors::Vector{InvalidCodeError}, c::CodeInfo)
```

Validate `c`, logging any violation by pushing an `InvalidCodeError` into `errors`.
