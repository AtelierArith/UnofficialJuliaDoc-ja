```julia
nzrange(x::SparseVectorUnion, col)
```

疎ベクトルの構造的な非ゼロ値のインデックス範囲を返します。列インデックス `col` は無視されます（`1` とみなされます）。
