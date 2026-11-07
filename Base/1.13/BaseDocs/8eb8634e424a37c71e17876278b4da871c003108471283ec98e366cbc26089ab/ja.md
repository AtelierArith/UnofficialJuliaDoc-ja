```julia
modifyglobal!(module::Module, name::Symbol, op, x, [order::Symbol=:monotonic])::Pair
```

関数 `op` を適用した後、グローバル変数の取得と設定をアトミックに実行します。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。


[`modifyproperty!`](@ref Base.modifyproperty!) および [`setglobal!`](@ref) も参照してください。
