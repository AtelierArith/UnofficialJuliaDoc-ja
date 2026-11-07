```julia
sparse_vcat(A...)
```

Concatenate along dimension 1. Return a SparseMatrixCSC object.

!!! compat "Julia 1.8"
    This method was added in Julia 1.8. It mimics previous concatenation behavior, where the concatenation with specialized "sparse" matrix types from LinearAlgebra.jl automatically yielded sparse output even in the absence of any SparseArray argument.

