```julia
@lock_nofail l expr
```

Equivalent to `@lock l expr` for cases in which we can guarantee that the function will not throw any error. In this case, avoiding try-catch can improve the performance. See [`@lock`](@ref).
