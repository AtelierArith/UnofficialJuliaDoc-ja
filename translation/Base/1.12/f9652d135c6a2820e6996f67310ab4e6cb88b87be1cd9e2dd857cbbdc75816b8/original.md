```julia
maxintfloat(T, S)
```

The largest consecutive integer representable in the given floating-point type `T` that also does not exceed the maximum integer representable by the integer type `S`.  Equivalently, it is the minimum of `maxintfloat(T)` and [`typemax(S)`](@ref).
