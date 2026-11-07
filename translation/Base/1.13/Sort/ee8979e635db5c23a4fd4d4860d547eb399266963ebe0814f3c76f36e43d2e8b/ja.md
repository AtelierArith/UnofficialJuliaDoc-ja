```julia
MissingOptimization(next) isa Base.Sort.Algorithm
```

欠損値を除外します。

欠損値は、`DirectOrdering`に従って、ほかの値の後ろに配置されます。このパスでは欠損値をその位置に移動し、欠損値を除いた元のベクトルのビューを渡します。このパスは、`sort([1, missing, 3])`と`sortperm([1, missing, 3])`の両方で実行されます。
