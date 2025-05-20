```
isunordered(x)
```

`x`が[`<`](@ref)に従って順序付けできない値（例えば`NaN`や`missing`）である場合、`true`を返します。

この述語で`true`と評価される値は、[`isless`](@ref)などの他の順序付けに関しては順序付け可能である場合があります。

!!! compat "Julia 1.7"
    この関数はJulia 1.7以降が必要です。

