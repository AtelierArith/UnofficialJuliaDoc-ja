```
move_fixed(x::AbstractSparseMatrixCSC)
```

実験的で安全ではありません。`x`のcolptr、rowvals、およびnonzerosを再利用して`FixedSparseCSC`を作成します。
