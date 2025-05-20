```
RowMaximum
```

The maximum-magnitude element in the remaining rows is chosen as the pivot element. This is the default strategy for LU factorization of floating-point matrices, and is sometimes referred to as the "partial pivoting" algorithm.

Note that the [element type](@ref eltype) of the matrix must admit an [`abs`](@ref) method, whose result type must admit a [`<`](@ref) method.
