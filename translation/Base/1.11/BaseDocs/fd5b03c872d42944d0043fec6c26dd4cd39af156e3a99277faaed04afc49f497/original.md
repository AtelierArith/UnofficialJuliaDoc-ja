```
Float32 <: AbstractFloat <: Real
```

32-bit floating point number type (IEEE 754 standard). Binary format is 1 sign, 8 exponent, 23 fraction bits.

The exponent for scientific notation should be entered as lower-case `f`, thus `2f3 === 2.0f0 * 10^3 === Float32(2_000)`. For array literals and comprehensions, the element type can be specified before the square brackets: `Float32[1,4,9] == Float32[i^2 for i in 1:3]`.

See also [`Inf32`](@ref), [`NaN32`](@ref), [`Float16`](@ref), [`exponent`](@ref), [`frexp`](@ref).
