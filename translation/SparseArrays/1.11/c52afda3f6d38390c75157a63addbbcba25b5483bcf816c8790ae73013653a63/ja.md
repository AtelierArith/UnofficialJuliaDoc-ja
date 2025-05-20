```
similar(A::AbstractSparseMatrixCSC{Tv,Ti}, [::Type{TvNew}, ::Type{TiNew}, m::Integer, n::Integer]) where {Tv,Ti}
```

与えられた要素型、インデックス型、およびサイズに基づいて、指定されたソース `SparseMatrixCSC` に基づいて初期化されていない可変配列を作成します。新しいスパース行列は、出力行列の次元が異なる場合を除いて、元のスパース行列の構造を維持します。

出力行列は、入力と同じ位置にゼロを持ちますが、非ゼロの位置には初期化されていない値を持ちます。
