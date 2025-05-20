```
div(x, y, r::RoundingMode=RoundToZero)
```

The quotient from Euclidean (integer) division. Computes `x / y`, rounded to an integer according to the rounding mode `r`. In other words, the quantity

```
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
