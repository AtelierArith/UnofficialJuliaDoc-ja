```julia
Float64 <: AbstractFloat <: Real
```

64-bit floating point number type (IEEE 754 standard). Binary format is 1 sign, 11 exponent, 52 fraction bits. See [`bitstring`](@ref), [`signbit`](@ref), [`exponent`](@ref), [`frexp`](@ref), and [`significand`](@ref) to access various bits.

This is the default for floating point literals, `1.0 isa Float64`, and for many operations such as `1/2, 2pi, log(2), range(0,90,length=4)`. Unlike integers, this default does not change with `Sys.WORD_SIZE`.

The exponent for scientific notation can be entered as `e` or `E`, thus `2e3 === 2.0E3 === 2.0 * 10^3`. Doing so is strongly preferred over `10^n` because integers overflow, thus `2.0 * 10^19 < 0` but `2e19 > 0`.

See also [`Inf`](@ref), [`NaN`](@ref), [`floatmax`](@ref), [`Float32`](@ref), [`Complex`](@ref).
