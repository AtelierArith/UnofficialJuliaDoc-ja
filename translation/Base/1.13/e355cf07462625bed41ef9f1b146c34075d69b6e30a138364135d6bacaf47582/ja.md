```julia
CyclePadding(padding, total_size)
```

`Padding` 構造体のイテレーターを循環させ、パディングを `total_size` から再開します。たとえば、構造体内のパディング全体が `padding` で、その配列のアラインメント後の合計サイズが `total_size` の場合、`CyclePadding` は、そのような構造体を無限に並べたベクトル内のパディングに対応します。
