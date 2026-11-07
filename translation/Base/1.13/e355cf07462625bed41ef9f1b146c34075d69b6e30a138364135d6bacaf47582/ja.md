```julia
CyclePadding(padding, total_size)
```

`Padding` 構造体のイテレーターを循環させ、`total_size` でパディングを再開します。たとえば、`padding` が構造体内のすべてのパディングで、`total_size` がその配列のアラインメント後の合計サイズである場合、`CyclePadding` は、そのような構造体を無限に並べたベクトル内のパディングに対応します。
