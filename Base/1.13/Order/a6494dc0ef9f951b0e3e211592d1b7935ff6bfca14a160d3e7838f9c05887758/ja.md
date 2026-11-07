```julia
Perm(order::Ordering, data::AbstractVector)
```

`Ordering` は、`data` のインデックスのうち、`i` が `j` より小さいものを、`data[i]` が `data[j]` より小さい場合に、`order` に従って並べ替えます。`data[i]` と `data[j]` が等しい場合は、`i` と `j` を数値として比較します。
