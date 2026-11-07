```julia
Base.hasfastin(T)
```

計算 `x ∈ collection`（ここで `collection::T`）が、「高速」な操作（通常、計算量が定数時間または対数時間）とみなせるかどうかを判定します。インスタンスを型の代わりに渡せるよう、便宜上 `hasfastin(x) = hasfastin(typeof(x))` も用意されています。ただし、新しい型では、型引数を受け取る形式を定義してください。

`hasfastin(T)` のデフォルト値は、[`AbstractSet`](@ref)、[`AbstractDict`](@ref)、[`AbstractRange`](@ref) のサブタイプでは `true`、それ以外では `false` です。
