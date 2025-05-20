```
Perm(order::Ordering, data::AbstractVector)
```

`Ordering`は`data`のインデックスに対して、`i`が`j`より小さい場合、`data[i]`が`data[j]`より小さいときに適用されます。`data[i]`と`data[j]`が等しい場合、`i`と`j`は数値で比較されます。
