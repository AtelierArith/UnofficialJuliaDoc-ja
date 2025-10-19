```julia
AbstractSparseArray{Tv,Ti,N}
```

`Tv`型の要素と`Ti`型のインデックスを持つ`N`次元スパース配列（または配列のような型）のスーパークラスです。 [`SparseMatrixCSC`](@ref)、[`SparseVector`](@ref)および`SuiteSparse.CHOLMOD.Sparse`はこのサブタイプです。
