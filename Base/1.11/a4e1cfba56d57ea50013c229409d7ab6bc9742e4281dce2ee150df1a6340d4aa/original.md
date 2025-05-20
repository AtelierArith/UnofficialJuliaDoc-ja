```
@allocations
```

A macro to evaluate an expression, discard the resulting value, and instead return the total number of allocations during evaluation of the expression.

See also [`@allocated`](@ref), [`@time`](@ref), [`@timev`](@ref), [`@timed`](@ref), and [`@elapsed`](@ref).

```julia-repl
julia> @allocations rand(10^6)
2
```

!!! compat "Julia 1.9"
    This macro was added in Julia 1.9.

