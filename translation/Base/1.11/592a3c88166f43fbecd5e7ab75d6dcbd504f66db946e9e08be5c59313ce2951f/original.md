```
@big_str str
```

Parse a string into a [`BigInt`](@ref) or [`BigFloat`](@ref), and throw an `ArgumentError` if the string is not a valid number. For integers `_` is allowed in the string as a separator.

# Examples

```jldoctest
julia> big"123_456"
123456

julia> big"7891.5"
7891.5

julia> big"_"
ERROR: ArgumentError: invalid number format _ for BigInt or BigFloat
[...]
```

!!! warning
    Using `@big_str` for constructing [`BigFloat`](@ref) values may not result in the behavior that might be naively expected: as a macro, `@big_str` obeys the global precision ([`setprecision`](@ref)) and rounding mode ([`setrounding`](@ref)) settings as they are at *load time*. Thus, a function like `() -> precision(big"0.3")` returns a constant whose value depends on the value of the precision at the point when the function is defined, **not** at the precision at the time when the function is called.

