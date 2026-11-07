```julia
IterableStatePairs(x)
```

This internal type is returned by [`pairs`](@ref), when the key is the same as the state of `iterate`. This allows the iterator to determine the key => value pairs by only calling iterate on the values.
