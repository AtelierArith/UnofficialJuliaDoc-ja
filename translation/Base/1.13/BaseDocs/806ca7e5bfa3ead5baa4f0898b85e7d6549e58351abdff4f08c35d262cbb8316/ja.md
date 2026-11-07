```julia
swapglobal!(module::Module, name::Symbol, x, [order::Symbol=:monotonic])
```

グローバル変数の取得と設定を同時に、アトミックに実行します。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。


関連項目: [`swapproperty!`](@ref Base.swapproperty!)、[`setglobal!`](@ref)。
