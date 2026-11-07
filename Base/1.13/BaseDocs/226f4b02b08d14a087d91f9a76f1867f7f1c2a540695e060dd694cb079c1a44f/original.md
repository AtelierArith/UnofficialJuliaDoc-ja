```julia
Int64 <: Signed <: Integer
```

64-bit signed integer type.

Note that such integers overflow without warning, thus `typemax(Int64) + Int64(1) < 0`.

See also [`Int`](@ref Int64), [`widen`](@ref), [`BigInt`](@ref).
