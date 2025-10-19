```julia
realloc(addr::Ptr, size::Integer) -> Ptr{Cvoid}
```

Call `realloc` from the C standard library.

See warning in the documentation for [`free`](@ref) regarding only using this on memory originally obtained from [`malloc`](@ref).
