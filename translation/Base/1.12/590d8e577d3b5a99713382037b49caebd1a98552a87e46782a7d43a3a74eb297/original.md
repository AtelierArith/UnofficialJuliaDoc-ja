```julia
memmove(dst::Ptr, src::Ptr, n::Integer) -> Ptr{Cvoid}
```

Call `memmove` from the C standard library.

!!! compat "Julia 1.10"
    Support for `memmove` requires at least Julia 1.10.

