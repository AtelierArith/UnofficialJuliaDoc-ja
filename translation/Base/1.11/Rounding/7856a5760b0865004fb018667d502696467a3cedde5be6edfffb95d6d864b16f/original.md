```
RoundingMode
```

A type used for controlling the rounding mode of floating point operations (via [`rounding`](@ref)/[`setrounding`](@ref) functions), or as optional arguments for rounding to the nearest integer (via the [`round`](@ref) function).

Currently supported rounding modes are:

  * [`RoundNearest`](@ref) (default)
  * [`RoundNearestTiesAway`](@ref)
  * [`RoundNearestTiesUp`](@ref)
  * [`RoundToZero`](@ref)
  * [`RoundFromZero`](@ref)
  * [`RoundUp`](@ref)
  * [`RoundDown`](@ref)

!!! compat "Julia 1.9"
    `RoundFromZero` requires at least Julia 1.9. Prior versions support `RoundFromZero` for `BigFloat`s only.

