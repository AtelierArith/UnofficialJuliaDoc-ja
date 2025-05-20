```
significand(x)
```

Extract the significand (a.k.a. mantissa) of a floating-point number. If `x` is a non-zero finite number, then the result will be a number of the same type and sign as `x`, and whose absolute value is on the interval $[1,2)$. Otherwise `x` is returned.

See also [`frexp`](@ref), [`exponent`](@ref).

# Examples

```jldoctest
julia> significand(15.2)
1.9

julia> significand(-15.2)
-1.9

julia> significand(-15.2) * 2^3
-15.2

julia> significand(-Inf), significand(Inf), significand(NaN)
(-Inf, Inf, NaN)
```
