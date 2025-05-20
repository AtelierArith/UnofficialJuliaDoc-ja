```
Base.hasfastin(T)
```

`collection::T` に対して `x ∈ collection` の計算が「高速」な操作（通常は定数または対数の複雑さ）と見なされるかどうかを判断します。便利のために `hasfastin(x) = hasfastin(typeof(x))` という定義が提供されているので、インスタンスを型の代わりに渡すことができます。ただし、型引数を受け取る形式は新しい型のために定義する必要があります。

`hasfastin(T)` のデフォルトは、[`AbstractSet`](@ref)、[`AbstractDict`](@ref)、および [`AbstractRange`](@ref) のサブタイプに対しては `true` であり、それ以外は `false` です。
