```julia
OrdinalRange{T, S} <: AbstractRange{T}
```

Supertype for ordinal ranges with elements of type `T` with spacing(s) of type `S`. The steps should be always-exact multiples of [`oneunit`](@ref), and `T` should be a "discrete" type, which cannot have values smaller than `oneunit`. For example, `Integer` or `Date` types would qualify, whereas `Float64` would not (since this type can represent values smaller than `oneunit(Float64)`. [`UnitRange`](@ref), [`StepRange`](@ref), and other types are subtypes of this.
