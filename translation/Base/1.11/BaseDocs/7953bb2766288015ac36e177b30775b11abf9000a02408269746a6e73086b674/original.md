```
Int8 <: Signed <: Integer
```

8-bit signed integer type.

Represents numbers `n ∈ -128:127`. Note that such integers overflow without warning, thus `typemax(Int8) + Int8(1) < 0`.

See also [`Int`](@ref Int64), [`widen`](@ref), [`BigInt`](@ref).
