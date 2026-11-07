```julia
replaceproperty!(x, f::Symbol, expected, desired, success_order::Symbol=:not_atomic, fail_order::Symbol=success_order)
```

egal に従って、`x.f` の値が `expected` の場合に、`desired` に置き換える比較交換操作を実行します。関数呼び出し形式の代わりに、`@atomicreplace x.f expected => desired` という構文も使用できます。

関連項目: [`replacefield!`](@ref Core.replacefield!) [`setproperty!`](@ref Base.setproperty!)、[`setpropertyonce!`](@ref Base.setpropertyonce!)。
