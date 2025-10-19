```julia
@allocated
```

A macro to evaluate an expression, discarding the resulting value, instead returning the total number of bytes allocated during evaluation of the expression.

If the expression is a function call, an effort is made to measure only allocations from the argument expressions and during the function, excluding any overhead from calling it and not performing constant propagation with the provided argument values. If you want to include those effects, i.e. measuring the call site as well, use the syntax `@allocated (()->f(1))()`.

It is recommended to measure function calls with only simple argument expressions, e.g. `x = []; @allocated f(x)` instead of `@allocated f([])` to clarify that only `f` is being measured.

For more complex expressions, the code is simply run in place and therefore may see allocations due to the surrounding context. For example it is possible for `@allocated f(1)` and `@allocated x = f(1)` to give different results.

See also [`@allocations`](@ref), [`@time`](@ref), [`@timev`](@ref), [`@timed`](@ref), and [`@elapsed`](@ref).

```julia-repl
julia> @allocated rand(10^6)
8000080
```
