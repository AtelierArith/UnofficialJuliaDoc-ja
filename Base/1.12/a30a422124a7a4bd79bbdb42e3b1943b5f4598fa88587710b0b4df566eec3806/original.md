```julia
rem(x, y, r::RoundingMode=RoundToZero)
```

Compute the remainder of `x` after integer division by `y`, with the quotient rounded according to the rounding mode `r`. In other words, the quantity

```julia
x - y * round(x / y, r)
```

without any intermediate rounding.

  * if `r == RoundNearest`, then the result is exact, and in the interval $[-|y| / 2, |y| / 2]$. See also [`RoundNearest`](@ref).
  * if `r == RoundToZero` (default), then the result is exact, and in the interval $[0, |y|)$ if `x` is positive, or $(-|y|, 0]$ otherwise. See also [`RoundToZero`](@ref).
  * if `r == RoundDown`, then the result is in the interval $[0, y)$ if `y` is positive, or $(y, 0]$ otherwise. The result may not be exact if `x` and `y` have different signs, and `abs(x) < abs(y)`. See also [`RoundDown`](@ref).
  * if `r == RoundUp`, then the result is in the interval $(-y, 0]$ if `y` is positive, or $[0, -y)$ otherwise. The result may not be exact if `x` and `y` have the same sign, and `abs(x) < abs(y)`. See also [`RoundUp`](@ref).
  * if `r == RoundFromZero`, then the result is in the interval $(-y, 0]$ if `y` is positive, or $[0, -y)$ otherwise. The result may not be exact if `x` and `y` have the same sign, and `abs(x) < abs(y)`. See also [`RoundFromZero`](@ref).

!!! compat "Julia 1.9"
    `RoundFromZero` requires at least Julia 1.9.


# Examples:

```jldoctest
julia> x = 9; y = 4;

julia> x % y  # same as rem(x, y)
1

julia> x ÷ y  # same as div(x, y)
2

julia> x == div(x, y) * y + rem(x, y)
true
```
