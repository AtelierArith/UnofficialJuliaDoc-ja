```julia
Base.hasfastin(T)
```

`collection::T` に対する計算 `x ∈ collection` が「高速」な操作（通常は定数または対数の複雑さ）と見なされるかどうかを判断します。便利のために、インスタンスを型の代わりに渡すことができるように `hasfastin(x) = hasfastin(typeof(x))` という定義が提供されています。ただし、型引数を受け取る形式は新しい型のために定義する必要があります。

`hasfastin(T)` のデフォルトは、[`AbstractSet`](@ref)、[`AbstractDict`](@ref)、および [`AbstractRange`](@ref) のサブタイプに対しては `true` であり、それ以外は `false` です。
