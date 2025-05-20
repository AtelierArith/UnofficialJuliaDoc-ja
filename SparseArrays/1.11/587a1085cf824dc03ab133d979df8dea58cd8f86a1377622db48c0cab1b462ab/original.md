```
SparseMatrixCSC{Tv,Ti<:Integer} <: AbstractSparseMatrixCSC{Tv,Ti}
```

Matrix type for storing sparse matrices in the [Compressed Sparse Column](@ref man-csc) format. The standard way of constructing SparseMatrixCSC is through the [`sparse`](@ref) function. See also [`spzeros`](@ref), [`spdiagm`](@ref) and [`sprand`](@ref).
