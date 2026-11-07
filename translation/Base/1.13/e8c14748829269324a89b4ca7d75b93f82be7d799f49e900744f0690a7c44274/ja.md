```julia
Base.hasfastin(T)
```

`collection::T` の場合に、計算 `x ∈ collection` を「高速」な操作（通常は定数時間または対数時間の計算量）とみなせるかどうかを判定します。定義 `hasfastin(x) = hasfastin(typeof(x))` は、型の代わりにインスタンスを渡せるようにするための便宜的なものです。ただし、新しい型については、型引数を受け取る形式を定義する必要があります。

`hasfastin(T)` のデフォルト値は、[`AbstractSet`](@ref)、[`AbstractDict`](@ref)、[`AbstractRange`](@ref) のサブタイプでは `true`、それ以外では `false` です。
