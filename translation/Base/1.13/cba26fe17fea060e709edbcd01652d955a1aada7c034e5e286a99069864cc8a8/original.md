```julia
_prechecked_iterate(iter[, state])
```

Internal function used to eliminate the dead branch in `iterate`. Fallback to `iterate` by default, but optimized for indices type in `Base`.
