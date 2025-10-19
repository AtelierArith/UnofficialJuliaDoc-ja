```julia
AbstractSparseArray{Tv,Ti,N}
```

Supertype for `N`-dimensional sparse arrays (or array-like types) with elements of type `Tv` and index type `Ti`. [`SparseMatrixCSC`](@ref), [`SparseVector`](@ref) and `SuiteSparse.CHOLMOD.Sparse` are subtypes of this.
