```julia
fbody = bodyfunction(basemethod::Method)
```

Find the keyword "body function" (the function that contains the body of the method as written, called after all missing keyword-arguments have been assigned default values). `basemethod` is the method you obtain via [`which`](@ref) or [`methods`](@ref).
