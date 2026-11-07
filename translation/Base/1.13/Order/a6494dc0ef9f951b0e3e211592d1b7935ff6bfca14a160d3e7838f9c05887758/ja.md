```julia
Perm(order::Ordering, data::AbstractVector)
```

`Ordering` は、`order` に従って、`i` が `j` より小さく、かつ `data[i]` が `data[j]` より小さい場合の、`data` のインデックスに対して適用されます。`data[i]` と `data[j]` が等しい場合は、`i` と `j` を数値で比較します。
