```julia
reset(::Event)
```

Reset an [`Event`](@ref) back into an un-set state. Then any future calls to `wait` will block until [`notify`](@ref) is called again.
