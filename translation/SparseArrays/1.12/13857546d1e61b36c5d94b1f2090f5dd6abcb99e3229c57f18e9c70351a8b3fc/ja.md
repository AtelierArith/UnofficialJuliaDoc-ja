```julia
nzrange(x::SparseVectorUnion, col)
```

スパースベクトルの構造的な非ゼロ値のインデックスの範囲を返します。列インデックス `col` は無視されます（`1` と仮定されます）。
