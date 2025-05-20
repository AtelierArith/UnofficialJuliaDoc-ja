```
@allocated
```

A macro to evaluate an expression, discarding the resulting value, instead returning the total number of bytes allocated during evaluation of the expression.

See also [`@allocations`](@ref), [`@time`](@ref), [`@timev`](@ref), [`@timed`](@ref), and [`@elapsed`](@ref).

```julia-repl
julia> @allocated rand(10^6)
8000080
```
