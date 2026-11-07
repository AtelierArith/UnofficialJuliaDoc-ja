```julia
Base.uabs(x::Integer)
```

Return the absolute value of `x`, possibly returning a different type should the operation be susceptible to overflow. This typically arises when `x` is a two's complement signed integer, so that `abs(typemin(x)) == typemin(x) < 0`, in which case the result of `uabs(x)` will be an unsigned integer of the same size.
