```julia
@fetch expr
```

Equivalent to `fetch(@spawnat :any expr)`. See [`fetch`](@ref) and [`@spawnat`](@ref).

# Examples

```julia-repl
julia> addprocs(3);

julia> @fetch myid()
2

julia> @fetch myid()
3

julia> @fetch myid()
4

julia> @fetch myid()
2
```
