```
@int128_str str
```

Parse `str` as an [`Int128`](@ref). Throw an `ArgumentError` if the string is not a valid integer.

# Examples

```jldoctest
julia> int128"123456789123"
123456789123

julia> int128"123456789123.4"
ERROR: LoadError: ArgumentError: invalid base 10 digit '.' in "123456789123.4"
[...]
```
