```julia
myid()
```

Get the id of the current process.

# Examples

```julia-repl
julia> myid()
1

julia> remotecall_fetch(() -> myid(), 4)
4
```
