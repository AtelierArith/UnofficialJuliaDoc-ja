```julia
abs2(x)
```

Squared absolute value of `x`.

This can be faster than `abs(x)^2`, especially for complex numbers where `abs(x)` requires a square root via [`hypot`](@ref).

See also [`abs`](@ref), [`conj`](@ref), [`real`](@ref).

# Examples

```jldoctest
julia> abs2(-3)
9

julia> abs2(3.0 + 4.0im)
25.0

julia> sum(abs2, [1+2im, 3+4im])  # LinearAlgebra.norm(x)^2
30
```
