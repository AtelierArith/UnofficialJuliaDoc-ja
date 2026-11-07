```julia
move_fixed(x::AbstractSparseMatrixCSC)
```

実験的であり、安全ではありません。`x` の colptr、rowvals、nonzeros を再利用して、`FixedSparseCSC` を作成します。
