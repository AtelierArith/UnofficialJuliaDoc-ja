```julia
Int32 <: Signed <: Integer
```

32-bit signed integer type.

Note that such integers overflow without warning, thus `typemax(Int32) + Int32(1) < 0`.

See also [`Int`](@ref Int64), [`widen`](@ref), [`BigInt`](@ref).
