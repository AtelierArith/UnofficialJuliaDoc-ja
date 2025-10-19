```julia
setrounding(f::Function, T, mode)
```

Change the rounding mode of floating point type `T` for the duration of `f`. It is logically equivalent to:

```julia
old = rounding(T)
setrounding(T, mode)
f()
setrounding(T, old)
```

See [`RoundingMode`](@ref) for available rounding modes.
