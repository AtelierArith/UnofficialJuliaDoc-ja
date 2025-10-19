```julia
@elapsed
```

A macro to evaluate an expression, discarding the resulting value, instead returning the number of seconds it took to execute as a floating-point number.

In some cases the system will look inside the `@elapsed` expression and compile some of the called code before execution of the top-level expression begins. When that happens, some compilation time will not be counted. To include this time you can run `@elapsed @eval ...`.

See also [`@time`](@ref), [`@timev`](@ref), [`@timed`](@ref), [`@allocated`](@ref), and [`@allocations`](@ref).

```julia-repl
julia> @elapsed sleep(0.3)
0.301391426
```
