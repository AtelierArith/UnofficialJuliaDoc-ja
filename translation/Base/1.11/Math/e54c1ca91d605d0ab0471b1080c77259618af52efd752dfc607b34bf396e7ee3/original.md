```
rem2pi(x, r::RoundingMode)
```

Compute the remainder of `x` after integer division by `2π`, with the quotient rounded according to the rounding mode `r`. In other words, the quantity

```
x - 2π*round(x/(2π),r)
```

without any intermediate rounding. This internally uses a high precision approximation of 2π, and so will give a more accurate result than `rem(x,2π,r)`

  * if `r == RoundNearest`, then the result is in the interval $[-π, π]$. This will generally be the most accurate result. See also [`RoundNearest`](@ref).
  * if `r == RoundToZero`, then the result is in the interval $[0, 2π]$ if `x` is positive,. or $[-2π, 0]$ otherwise. See also [`RoundToZero`](@ref).
  * if `r == RoundDown`, then the result is in the interval $[0, 2π]$. See also [`RoundDown`](@ref).
  * if `r == RoundUp`, then the result is in the interval $[-2π, 0]$. See also [`RoundUp`](@ref).

# Examples

```jldoctest
julia> rem2pi(7pi/4, RoundNearest)
-0.7853981633974485

julia> rem2pi(7pi/4, RoundDown)
5.497787143782138
```
