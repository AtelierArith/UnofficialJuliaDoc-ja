```julia
Base.mapreduce_first(f, op, x)
```

The value to be returned when calling [`mapreduce`](@ref), [`mapfoldl`](@ref) or [`mapfoldr`](@ref) with map `f` and reduction `op` over an iterator which contains a single element `x`. This value may also be used to initialise the recursion, so that `mapreduce(f, op, [x, y])` may call `op(mapreduce_first(f, op, x), f(y))`.

The default is `reduce_first(op, f(x))`.
