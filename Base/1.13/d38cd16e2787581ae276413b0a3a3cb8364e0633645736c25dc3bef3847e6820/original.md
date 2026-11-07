```julia
isequal(x)
```

Create a function that compares its argument to `x` using [`isequal`](@ref), i.e. a function equivalent to `y -> isequal(y, x)`.

The returned function is of type `Base.Fix2{typeof(isequal)}`, which can be used to implement specialized methods.
