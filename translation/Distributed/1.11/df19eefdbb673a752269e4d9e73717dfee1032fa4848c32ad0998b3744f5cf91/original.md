```julia
procs()
```

Return a list of all process identifiers, including pid 1 (which is not included by [`workers()`](@ref)).

# Examples

```julia-repl
$ julia -p 2

julia> procs()
3-element Array{Int64,1}:
 1
 2
 3
```
