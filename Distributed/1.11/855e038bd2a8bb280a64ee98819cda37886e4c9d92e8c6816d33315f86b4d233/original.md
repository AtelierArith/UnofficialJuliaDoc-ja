```
@fetchfrom
```

Equivalent to `fetch(@spawnat p expr)`. See [`fetch`](@ref) and [`@spawnat`](@ref).

# Examples

```julia-repl
julia> addprocs(3);

julia> @fetchfrom 2 myid()
2

julia> @fetchfrom 4 myid()
4
```
