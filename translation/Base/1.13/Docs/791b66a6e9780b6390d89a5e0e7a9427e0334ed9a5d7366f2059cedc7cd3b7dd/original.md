```julia
MultiDoc
```

Stores a collection of docstrings for related objects, ie. a `Function`/`DataType` and associated `Method` objects.

Each documented object in a `MultiDoc` is referred to by its signature which is represented by a `Union` of `Tuple` types. For example, the following `Method` definition

```julia
f(x, y) = ...
```

is stored as `Tuple{Any, Any}` in the `MultiDoc` while

```julia
f(x::T, y = ?) where {T} = ...
```

is stored as `Union{Tuple{T, Any}, Tuple{T}} where T`.

Note: The `Function`/`DataType` object's signature is always `Union{}`.
