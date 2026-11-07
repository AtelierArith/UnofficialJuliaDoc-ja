```julia
RowMaximum
```

A row (and potentially also column) pivot is chosen based on a maximum property. This is the default strategy for LU factorization and for pivoted Cholesky factorization (though [`NoPivot`] is the default for [`cholesky`](@ref)).

In the LU case, the maximum-magnitude element within the current column in the remaining rows is chosen as the pivot element. This is sometimes referred to as the "partial pivoting" algorithm. In this case, the [element type](@ref eltype) of the matrix must admit an [`abs`](@ref) method, whose result type must admit a [`<`](@ref) method.

In the Cholesky case, the maximal element among the remaining diagonal elements is chosen as the pivot element. This is sometimes referred to as the "diagonal pivoting" algorithm, and leads to *complete pivoting* (i.e., of both rows and columns by the same permutation). In this case, the (real part of the) [element type](@ref eltype) of the matrix must admit a [`<`](@ref) method.
