```julia
ismutabletype(T)::Bool
```

`T` 型が可変型として宣言されているか（つまり、`mutable struct` キーワードを使って宣言されているか）を判定します。`T` が型でない場合は、`false` を返します。

!!! compat "Julia 1.7"
    この関数を使用するには、Julia 1.7 以降が必要です。

