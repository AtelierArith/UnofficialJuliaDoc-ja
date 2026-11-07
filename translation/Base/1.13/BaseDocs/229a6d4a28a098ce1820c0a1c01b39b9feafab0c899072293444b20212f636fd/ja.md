```julia
setpropertyonce!(x, f::Symbol, value, success_order::Symbol=:not_atomic, fail_order::Symbol=success_order)
```

`x.f`に対して比較交換操作を行い、未設定の場合は`value`に設定します。関数呼び出し形式の代わりに、`@atomiconce x.f = value`という構文も使用できます。

関連項目: [`setfieldonce!`](@ref Core.replacefield!)、[`setproperty!`](@ref Base.setproperty!)、[`replaceproperty!`](@ref Base.replaceproperty!)。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11以降が必要です。

