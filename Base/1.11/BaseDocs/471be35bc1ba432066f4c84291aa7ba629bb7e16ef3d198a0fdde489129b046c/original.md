```
InexactError(name::Symbol, T, val)
```

Cannot exactly convert `val` to type `T` in a method of function `name`.

# Examples

```jldoctest
julia> convert(Float64, 1+2im)
ERROR: InexactError: Float64(1 + 2im)
Stacktrace:
[...]
```
