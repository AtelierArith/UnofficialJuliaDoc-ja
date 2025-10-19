```julia
workers()
```

Return a list of all worker process identifiers.

# Examples

```julia-repl
$ julia -p 2

julia> workers()
2-element Array{Int64,1}:
 2
 3
```
