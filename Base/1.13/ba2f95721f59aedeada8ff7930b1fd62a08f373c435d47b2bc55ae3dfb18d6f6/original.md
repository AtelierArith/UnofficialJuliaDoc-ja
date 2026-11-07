```julia
div(x, y, r::RoundingMode=RoundToZero)
```

The quotient from Euclidean (integer) division. Computes `x / y`, rounded to an integer according to the rounding mode `r`. In other words, the quantity

```julia
round(x / y, r)
```

without any intermediate rounding.

!!! compat "Julia 1.4"
    The three-argument method taking a `RoundingMode` requires Julia 1.4 or later.


See also [`fld`](@ref) and [`cld`](@ref), which are special cases of this function.

!!! compat "Julia 1.9"
    `RoundFromZero` requires at least Julia 1.9.


# Examples:

```jldoctest
julia> div(4, 3, RoundToZero) # Matches div(4, 3)
1
julia> div(4, 3, RoundDown) # Matches fld(4, 3)
1
julia> div(4, 3, RoundUp) # Matches cld(4, 3)
2
julia> div(5, 2, RoundNearest)
2
julia> div(5, 2, RoundNearestTiesAway)
3
julia> div(-5, 2, RoundNearest)
-2
julia> div(-5, 2, RoundNearestTiesAway)
-3
julia> div(-5, 2, RoundNearestTiesUp)
-2
julia> div(4, 3, RoundFromZero)
2
julia> div(-4, 3, RoundFromZero)
-2
```

Because `div(x, y)` implements strictly correct truncated rounding based on the true value of floating-point numbers, unintuitive situations can arise. For example:

```jldoctest
julia> div(6.0, 0.1)
59.0
julia> 6.0 / 0.1
60.0
julia> 6.0 / big(0.1)
59.99999999999999666933092612453056361837965690217069245739573412231113406246995
```

What is happening here is that the true value of the floating-point number written as `0.1` is slightly larger than the numerical value 1/10 while `6.0` represents the number 6 precisely. Therefore the true value of `6.0 / 0.1` is slightly less than 60. When doing division, this is rounded to precisely `60.0`, but `div(6.0, 0.1, RoundToZero)` always truncates the true value, so the result is `59.0`.
