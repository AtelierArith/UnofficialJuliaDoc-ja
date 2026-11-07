```julia
SparseMatrixCSC{Tv,Ti}(::UndefInitializer, m::Integer, n::Integer)
SparseMatrixCSC{Tv,Ti}(::UndefInitializer, (m,n)::NTuple{2,Integer})
```

要素型が `Tv`、整数型が `Ti` で、サイズが `m × n` の空の疎行列を作成します。
