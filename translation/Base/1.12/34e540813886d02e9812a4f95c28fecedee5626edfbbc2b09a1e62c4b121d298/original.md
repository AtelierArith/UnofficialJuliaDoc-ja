```julia
sizehint!(s, n; first::Bool=false, shrink::Bool=true) -> s
```

Suggest that collection `s` reserve capacity for at least `n` elements. That is, if you expect that you're going to have to push a lot of values onto `s`, you can avoid the cost of incremental reallocation by doing it once up front; this can improve performance.

If `first` is `true`, then any additional space is reserved before the start of the collection. This way, subsequent calls to `pushfirst!` (instead of `push!`) may become faster. Supplying this keyword may result in an error if the collection is not ordered or if `pushfirst!` is not supported for this collection.

If `shrink=true` (the default), the collection's capacity may be reduced if its current capacity is greater than `n`.

See also [`resize!`](@ref).

# Notes on the performance model

For types that support `sizehint!`,

1. `push!` and `append!` methods generally may (but are not required to) preallocate extra storage. For types implemented in `Base`, they typically do, using a heuristic optimized for a general use case.
2. `sizehint!` may control this preallocation. Again, it typically does this for types in `Base`.
3. `empty!` is nearly costless (and O(1)) for types that support this kind of preallocation.

!!! compat "Julia 1.11"
    The `shrink` and `first` arguments were added in Julia 1.11.

