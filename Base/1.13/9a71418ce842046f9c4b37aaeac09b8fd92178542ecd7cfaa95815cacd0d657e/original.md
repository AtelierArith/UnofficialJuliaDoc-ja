```julia
open_flags(; keywords...)::NamedTuple
```

Compute the `read`, `write`, `create`, `truncate`, `append` flag value for a given set of keyword arguments to [`open`](@ref) a [`NamedTuple`](@ref).
