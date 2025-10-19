```julia
atand(y::T) where T -> float(T)
atand(y::T, x::S) where {T,S} -> promote_type(T,S)
atand(y::AbstractMatrix{T}) where T -> AbstractMatrix{Complex{float(T)}}
```

`y`または`y/x`の逆タンジェントを計算します。出力は度数法です。

`isnan(y)`または`isnan(x)`の場合、`NaN`を返します。返される`NaN`は、単一引数バージョンでは`T`、二引数バージョンでは`promote_type(T,S)`です。

!!! compat "Julia 1.7"
    単一引数メソッドは、Julia 1.7以降、正方行列引数をサポートしています。

