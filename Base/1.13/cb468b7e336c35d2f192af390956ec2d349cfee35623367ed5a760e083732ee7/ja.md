```julia
isstructtype(T)::Bool
```

型 `T` が構造体型（つまり、`struct` または `mutable struct` キーワードを使って宣言された型）かどうかを判定します。`T` が型でない場合は、`false` を返します。
