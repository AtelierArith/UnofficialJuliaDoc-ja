```julia
_enum_hash(x::Enum, h::UInt)
```

Compute hash for an enum value `x`. This internal method will be specialized for every enum type created through [`@enum`](@ref).
