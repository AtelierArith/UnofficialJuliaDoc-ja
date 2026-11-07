```julia
@timed
```

A macro to execute an expression, and return the value of the expression, elapsed time in seconds, total bytes allocated, garbage collection time, an object with various memory allocation counters, compilation time in seconds, and recompilation time in seconds. Any lock conflicts where a [`ReentrantLock`](@ref) had to wait are shown as a count.

In some cases the system will look inside the `@timed` expression and compile some of the called code before execution of the top-level expression begins. When that happens, some compilation time will not be counted. To include this time you can run `@timed @eval ...`.

See also [`@time`](@ref), [`@timev`](@ref), [`@elapsed`](@ref), [`@allocated`](@ref), [`@allocations`](@ref), and [`@lock_conflicts`](@ref).

```julia-repl
julia> stats = @timed rand(10^6);

julia> stats.time
0.006634834

julia> stats.bytes
8000256

julia> stats.gctime
0.0055765

julia> propertynames(stats.gcstats)
(:allocd, :malloc, :realloc, :poolalloc, :bigalloc, :freecall, :total_time, :pause, :full_sweep)

julia> stats.gcstats.total_time
5576500

julia> stats.compile_time
0.0

julia> stats.recompile_time
0.0

```

!!! compat "Julia 1.5"
    The return type of this macro was changed from `Tuple` to `NamedTuple` in Julia 1.5.


!!! compat "Julia 1.11"
    The `lock_conflicts`, `compile_time`, and `recompile_time` fields were added in Julia 1.11.

