```
>>>(x, n)
```

Unsigned right bit shift operator, `x >>> n`. For `n >= 0`, the result is `x` shifted right by `n` bits, filling with `0`s. For `n < 0`, this is equivalent to `x << -n`.

For [`Unsigned`](@ref) integer types, this is equivalent to [`>>`](@ref). For [`Signed`](@ref) integer types, this is equivalent to `signed(unsigned(x) >> n)`.

# Examples

```jldoctest
julia> Int8(-14) >>> 2
60

julia> bitstring(Int8(-14))
"11110010"

julia> bitstring(Int8(60))
"00111100"
```

[`BigInt`](@ref)s are treated as if having infinite size, so no filling is required and this is equivalent to [`>>`](@ref).

See also [`>>`](@ref), [`<<`](@ref).
