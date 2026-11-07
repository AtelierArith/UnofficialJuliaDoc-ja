```julia
@showtime expr
```

Like `@time` but also prints the expression being evaluated for reference.

!!! compat "Julia 1.8"
    This macro was added in Julia 1.8.


See also [`@time`](@ref).

```julia-repl
julia> @showtime sleep(1)
sleep(1): 1.002164 seconds (4 allocations: 128 bytes)
```
