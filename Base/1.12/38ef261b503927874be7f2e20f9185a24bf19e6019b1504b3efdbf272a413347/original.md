```julia
precision(num::AbstractFloat; base::Integer=2)
precision(T::Type; base::Integer=2)
```

Get the precision of a floating point number, as defined by the effective number of bits in the significand, or the precision of a floating-point type `T` (its current default, if `T` is a variable-precision type like [`BigFloat`](@ref)).

If `base` is specified, then it returns the maximum corresponding number of significand digits in that base.

!!! compat "Julia 1.8"
    The `base` keyword requires at least Julia 1.8.

