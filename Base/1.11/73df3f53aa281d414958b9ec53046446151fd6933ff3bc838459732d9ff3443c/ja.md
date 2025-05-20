```
ismutabletype(T) -> Bool
```

型 `T` が可変型として宣言されたかどうかを判断します（すなわち、`mutable struct` キーワードを使用して）。`T` が型でない場合は、`false` を返します。

!!! compat "Julia 1.7"
    この関数は少なくとも Julia 1.7 が必要です。

