```julia
ColumnNorm
```

The column with the maximum norm is used for subsequent computation. This is used for pivoted QR factorization.

Note that the [element type](@ref eltype) of the matrix must admit [`norm`](@ref) and [`abs`](@ref) methods, whose respective result types must admit a [`<`](@ref) method.
