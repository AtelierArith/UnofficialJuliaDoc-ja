```julia
isunordered(x)
```

`x`が[`<`](@ref)に従って順序付けできない値（`NaN`や`missing`など）の場合、`true`を返します。

この述語で`true`と評価される値でも、[`isless`](@ref)など、別の順序関係では順序付けできる場合があります。

!!! compat "Julia 1.7"
    この関数を使用するには、Julia 1.7以降が必要です。

