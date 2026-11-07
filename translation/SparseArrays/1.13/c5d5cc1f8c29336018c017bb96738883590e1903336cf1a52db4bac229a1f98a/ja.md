```julia
AbstractSparseArray{Tv,Ti,N}
```

要素型が`Tv`、インデックス型が`Ti`である、`N`次元の疎配列（または配列に類する型）のスーパータイプです。[`SparseMatrixCSC`](@ref)、[`SparseVector`](@ref)、`SuiteSparse.CHOLMOD.Sparse`は、この型のサブタイプです。
