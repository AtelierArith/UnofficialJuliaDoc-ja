```julia
addcache!(cache::Vector{T}, state::Unsigned, new::T)
```

`new`を、`state`に従って、ログ構造化された`cache`に追加します。

`new`の寿命は指数関数的に減衰します。キャッシュ内で`k`番目の位置に到達する確率は、`2^(k-1)`における`1`です。

キャッシュには、`state`のビット数と同じ数の項目を格納できます（例：`UInt8`の場合は8）。
