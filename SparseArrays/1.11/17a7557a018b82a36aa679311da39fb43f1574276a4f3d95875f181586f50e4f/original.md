```
move_fixed(x::AbstractSparseMatrixCSC)
```

Experimental, unsafe. Make a `FixedSparseCSC` by reusing the colptr, rowvals and nonzeros of `x`.
