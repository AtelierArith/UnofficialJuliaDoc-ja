```
dlopen_e(libfile::AbstractString [, flags::Integer])
```

Similar to [`dlopen`](@ref), except returns `C_NULL` instead of raising errors. This method is now deprecated in favor of `dlopen(libfile::AbstractString [, flags::Integer]; throw_error=false)`.
