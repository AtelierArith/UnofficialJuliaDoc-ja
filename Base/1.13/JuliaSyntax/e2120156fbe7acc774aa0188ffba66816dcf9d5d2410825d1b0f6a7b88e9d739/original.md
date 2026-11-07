```julia
char_range(x)
```

Compute the range in *character indices* over the source text for syntax object `x`. If you want to index the source string you need this, rather than [`byte_range`](@ref).
