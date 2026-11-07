```julia
@uint128_str str
```

Parse `str` as an [`UInt128`](@ref). Throw an `ArgumentError` if the string is not a valid integer.

# Examples

```julia
julia> uint128"123456789123"
0x00000000000000000000001cbe991a83

julia> uint128"-123456789123"
ERROR: LoadError: ArgumentError: invalid base 10 digit '-' in "-123456789123"
[...]
```
