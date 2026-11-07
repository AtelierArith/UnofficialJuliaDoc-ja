```julia
SparseVector{Tv,Ti<:Integer} <: AbstractSparseVector{Tv,Ti}
```

Vector type for storing sparse vectors. Can be created by passing the length of the vector, a *sorted* vector of non-zero indices, and a vector of non-zero values.

For instance, the vector `[5, 6, 0, 7]` can be represented as

```julia
SparseVector(4, [1, 2, 4], [5, 6, 7])
```

This indicates that the element at index 1 is 5, at index 2 is 6, at index 3 is `zero(Int)`, and at index 4 is 7.

It may be more convenient to create sparse vectors directly from dense vectors using `sparse` as

```julia
sparse([5, 6, 0, 7])
```

yields the same sparse vector.
