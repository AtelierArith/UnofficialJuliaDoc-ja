```julia
decode_overlong(c::AbstractChar)::Integer
```

When [`isoverlong(c)`](@ref) is `true`, `decode_overlong(c)` returns the Unicode codepoint value of `c`. `AbstractChar` implementations that support overlong encodings should implement `Base.decode_overlong`.
