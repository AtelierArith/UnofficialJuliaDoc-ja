```julia
to_index(i)
```

Convert index `i` to an `Int` or array of `Int`s to be used as an index for all arrays.

Custom index types may specialize `to_index(::CustomIndex)` to provide special indexing behaviors. This must return either an `Int` or an `AbstractArray` of `Int`s.
