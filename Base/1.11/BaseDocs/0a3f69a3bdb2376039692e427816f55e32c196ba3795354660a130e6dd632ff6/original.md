```
Int16 <: Signed <: Integer
```

16-bit signed integer type.

Represents numbers `n ∈ -32768:32767`. Note that such integers overflow without warning, thus `typemax(Int16) + Int16(1) < 0`.

See also [`Int`](@ref Int64), [`widen`](@ref), [`BigInt`](@ref).
