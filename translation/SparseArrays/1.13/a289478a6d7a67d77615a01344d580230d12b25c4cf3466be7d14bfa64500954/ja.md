```julia
similar(A::AbstractSparseMatrixCSC{Tv,Ti}, [::Type{TvNew}, ::Type{TiNew}, m::Integer, n::Integer]) where {Tv,Ti}
```

指定された要素型、インデックス型、サイズを持つ、未初期化の可変配列を、指定されたソース `SparseMatrixCSC` に基づいて作成します。新しい疎行列は、出力行列の次元が異なる場合を除き、元の疎行列の構造を維持します。

出力行列では、入力と同じ位置にゼロが配置され、非ゼロの位置には未初期化の値が格納されます。
