```
@timev expr
@timev "description" expr
```

This is a verbose version of the `@time` macro. It first prints the same information as `@time`, then any non-zero memory allocation counters, and then returns the value of the expression.

Optionally provide a description string to print before the time report.

!!! compat "Julia 1.8"
    The option to add a description was introduced in Julia 1.8.


See also [`@time`](@ref), [`@timed`](@ref), [`@elapsed`](@ref), [`@allocated`](@ref), and [`@allocations`](@ref).

```julia-repl
julia> x = rand(10,10);

julia> @timev x * x;
  0.546770 seconds (2.20 M allocations: 116.632 MiB, 4.23% gc time, 99.94% compilation time)
elapsed time (ns): 546769547
gc time (ns):      23115606
bytes allocated:   122297811
pool allocs:       2197930
non-pool GC allocs:1327
malloc() calls:    36
realloc() calls:   5
GC pauses:         3

julia> @timev x * x;
  0.000010 seconds (1 allocation: 896 bytes)
elapsed time (ns): 9848
bytes allocated:   896
pool allocs:       1
```
