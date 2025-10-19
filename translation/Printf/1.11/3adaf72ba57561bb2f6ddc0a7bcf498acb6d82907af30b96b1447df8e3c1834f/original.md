```julia
Printf.format(f::Printf.Format, args...) => String
Printf.format(io::IO, f::Printf.Format, args...)
```

Apply a printf format object `f` to provided `args` and return the formatted string (1st method), or print directly to an `io` object (2nd method). See [`@printf`](@ref) for more details on C `printf` support.
