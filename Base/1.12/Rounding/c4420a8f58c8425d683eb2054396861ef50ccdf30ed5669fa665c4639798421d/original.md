```julia
rounding(T)
```

Get the current floating point rounding mode for type `T`, controlling the rounding of basic arithmetic functions ([`+`](@ref), [`-`](@ref), [`*`](@ref), [`/`](@ref) and [`sqrt`](@ref)) and type conversion.

See [`RoundingMode`](@ref) for available modes.
