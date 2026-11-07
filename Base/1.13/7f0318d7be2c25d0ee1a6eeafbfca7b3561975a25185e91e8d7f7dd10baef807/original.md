```julia
isdisjoint(x)
```

Create a function that compares its argument to `x` using [`isdisjoint`](@ref), i.e. a function equivalent to `y -> isdisjoint(y, x)`. The returned function is of type `Base.Fix2{typeof(isdisjoint)}`, which can be used to implement specialized methods.

!!! compat "Julia 1.11"
    This functionality requires at least Julia 1.11.

