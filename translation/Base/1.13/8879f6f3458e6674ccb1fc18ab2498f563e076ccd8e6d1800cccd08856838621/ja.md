```julia
ismutabletype(T)::Bool
```

型 `T` が可変型（つまり、`mutable struct` キーワードを使って宣言された型）かどうかを判定します。`T` が型でない場合は、`false` を返します。

!!! compat "Julia 1.7"
    この関数を使用するには、Julia 1.7 以降が必要です。

