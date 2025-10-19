```julia
isstructtype(T) -> Bool
```

型 `T` が構造体型として宣言されたかどうかを判断します（すなわち、`struct` または `mutable struct` キーワードを使用して）。もし `T` が型でない場合は、`false` を返します。
