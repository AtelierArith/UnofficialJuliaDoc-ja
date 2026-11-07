```julia
tmerge_field(𝕃::AbstractLattice, a, b) -> nothing or lattice element
```

`𝕃` 上で、要素 `a` と `b` の格子結合を計算します。`a` と `b` は、`PartialStruct` または `Const` のフィールドです。これは、外部の格子実装が独自のフィールドマージ戦略を提供できるようにするオプトイン型のインターフェースです。`nothing` を返した場合、`tmerge(::PartialsLattice, ...)` は、収束に至るまで再帰的に `tmerge` を使用しない、デフォルトの積極的な型マージ実装を使用します。
