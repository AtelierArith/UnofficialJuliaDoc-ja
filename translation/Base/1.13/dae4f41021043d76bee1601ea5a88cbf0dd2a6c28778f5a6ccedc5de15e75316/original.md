```julia
Base.reduce_first(op, x)
```

The value to be returned when calling [`reduce`](@ref), [`foldl`](@ref) or [`foldr`](@ref) with reduction `op` over an iterator which contains a single element `x`. This value may also be used to initialise the recursion, so that `reduce(op, [x, y])` may call `op(reduce_first(op, x), y)`.

The default is `x` for most types. The main purpose is to ensure type stability, so additional methods should only be defined for cases where `op` gives a result with different types than its inputs.
