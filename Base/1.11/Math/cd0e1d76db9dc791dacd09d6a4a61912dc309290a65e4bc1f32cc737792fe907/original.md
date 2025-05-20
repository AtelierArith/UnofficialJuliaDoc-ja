```
exponent(x::Real) -> Int
```

Returns the largest integer `y` such that `2^y ≤ abs(x)`.

Throws a `DomainError` when `x` is zero, infinite, or [`NaN`](@ref). For any other non-subnormal floating-point number `x`, this corresponds to the exponent bits of `x`.

See also [`signbit`](@ref), [`significand`](@ref), [`frexp`](@ref), [`issubnormal`](@ref), [`log2`](@ref), [`ldexp`](@ref).

# Examples

```jldoctest
julia> exponent(8)
3

julia> exponent(6.5)
2

julia> exponent(-1//4)
-2

julia> exponent(3.142e-4)
-12

julia> exponent(floatmin(Float32)), exponent(nextfloat(0.0f0))
(-126, -149)

julia> exponent(0.0)
ERROR: DomainError with 0.0:
Cannot be ±0.0.
[...]
```
