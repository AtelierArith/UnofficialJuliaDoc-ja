```julia
setrounding(T, mode)
```

Set the rounding mode of floating point type `T`, controlling the rounding of basic arithmetic functions ([`+`](@ref), [`-`](@ref), [`*`](@ref), [`/`](@ref) and [`sqrt`](@ref)) and type conversion. Other numerical functions may give incorrect or invalid values when using rounding modes other than the default [`RoundNearest`](@ref).

Note that this is currently only supported for `T == BigFloat`.

!!! warning
    This function is not thread-safe. It will affect code running on all threads, but its behavior is undefined if called concurrently with computations that use the setting.

