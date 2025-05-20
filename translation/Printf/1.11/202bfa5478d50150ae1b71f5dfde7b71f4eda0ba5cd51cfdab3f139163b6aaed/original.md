```
Printf.tofloat(x)
```

Convert an argument to a Base float type for printf formatting. By default, arguments are converted to `Float64` via `Float64(x)`. Custom numeric types that have a conversion to a Base float type that wish to hook into printf formatting can extend this method like:

```julia
Printf.tofloat(x::MyCustomType) = convert_my_custom_type_to_float(x)
```

For arbitrary precision numerics, you might extend the method like:

```julia
Printf.tofloat(x::MyArbitraryPrecisionType) = BigFloat(x)
```

!!! compat "Julia 1.6"
    This function requires Julia 1.6 or later.

