```julia
Int128 <: Signed <: Integer
```

128-bit signed integer type.

Note that such integers overflow without warning, thus `typemax(Int128) + Int128(1) < 0`.

See also [`Int`](@ref Int64), [`widen`](@ref), [`BigInt`](@ref).
