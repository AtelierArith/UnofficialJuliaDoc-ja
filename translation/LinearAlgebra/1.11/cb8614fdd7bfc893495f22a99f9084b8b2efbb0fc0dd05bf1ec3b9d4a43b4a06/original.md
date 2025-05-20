```
hermitian_type(T::Type)
```

The type of the object returned by `hermitian(::T, ::Symbol)`. For matrices, this is an appropriately typed `Hermitian`, for `Number`s, it is the original type. If `hermitian` is implemented for a custom type, so should be `hermitian_type`, and vice versa.
