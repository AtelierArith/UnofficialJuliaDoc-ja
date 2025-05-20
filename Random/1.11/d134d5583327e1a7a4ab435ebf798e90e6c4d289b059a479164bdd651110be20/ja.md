```
hash_seed(seed) -> AbstractVector{UInt8}
```

`seed`の256ビット（32バイト）の暗号学的ハッシュを返します。`seed`は現在、`Union{Integer, AbstractString, AbstractArray{UInt32}, AbstractArray{UInt64}}`の型である必要がありますが、モジュールは自分の型に対してこの関数を拡張できます。

`hash_seed`は「単射」です：もし`n != m`であれば、`hash_seed(n) != hash*seed(m)`です。さらに、もし`n == m`であれば、`hash*seed(n) == hash_seed(m)`です。

これは変更される可能性のある内部関数です。
