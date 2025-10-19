```julia
mod2pi(x)
```

Modulus after division by `2π`, returning in the range $[0,2π)$.

This function computes a floating point representation of the modulus after division by numerically exact `2π`, and is therefore not exactly the same as `mod(x,2π)`, which would compute the modulus of `x` relative to division by the floating-point number `2π`.

!!! note
    Depending on the format of the input value, the closest representable value to 2π may be less than 2π. For example, the expression `mod2pi(2π)` will not return `0`, because the intermediate value of `2*π` is a `Float64` and `2*Float64(π) < 2*big(π)`. See [`rem2pi`](@ref) for more refined control of this behavior.


# Examples

```jldoctest
julia> mod2pi(9*pi/4)
0.7853981633974481
```
