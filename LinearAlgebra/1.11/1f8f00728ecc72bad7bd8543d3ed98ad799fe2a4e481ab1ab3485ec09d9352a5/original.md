```
symmetric_type(T::Type)
```

The type of the object returned by `symmetric(::T, ::Symbol)`. For matrices, this is an appropriately typed `Symmetric`, for `Number`s, it is the original type. If `symmetric` is implemented for a custom type, so should be `symmetric_type`, and vice versa.
