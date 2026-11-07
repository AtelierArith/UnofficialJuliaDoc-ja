```julia
to_index(A, i)
```

Convert index `i` to an `Int` or array of indices to be used as an index into array `A`.

Custom array types may specialize `to_index(::CustomArray, i)` to provide special indexing behaviors. Note that some index types (like `Colon`) require more context in order to transform them into an array of indices; those get converted in the more complicated `to_indices` function. By default, this simply calls the generic `to_index(i)`. This must return either an `Int` or an `AbstractArray` of scalar indices that are supported by `A`.
