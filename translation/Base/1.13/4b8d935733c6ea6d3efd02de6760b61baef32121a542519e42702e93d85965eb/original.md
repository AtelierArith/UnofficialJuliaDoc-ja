```julia
@_safeindex
```

This internal macro converts:

  * `getindex(xs::Tuple, i::Int)` -> `__safe_getindex(xs, i)`
  * `setindex!(xs::Vector{T}, x, i::Int)` -> `__safe_setindex!(xs, x, i)`

to tell the compiler that indexing operations within the applied expression are always inbounds and do not need to taint `:consistent` and `:nothrow`.
