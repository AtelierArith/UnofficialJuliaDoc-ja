```julia
isstructtype(T)::Bool
```

型 `T` が構造体型として宣言されているか（つまり、`struct` または `mutable struct` キーワードを使って宣言されているか）を判定します。`T` が型でない場合は、`false` を返します。
