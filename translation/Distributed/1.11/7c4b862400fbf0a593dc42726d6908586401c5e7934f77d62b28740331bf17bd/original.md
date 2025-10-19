```julia
nworkers()
```

Get the number of available worker processes. This is one less than [`nprocs()`](@ref). Equal to `nprocs()` if `nprocs() == 1`.

# Examples

```julia-repl
$ julia -p 2

julia> nprocs()
3

julia> nworkers()
2
```
