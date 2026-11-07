```julia
replaceproperty!(x, f::Symbol, expected, desired, success_order::Symbol=:not_atomic, fail_order::Symbol=success_order)
```

egal に従って、`x.f` を `expected` から `desired` に比較交換します。関数呼び出し形式の代わりに、構文 `@atomicreplace x.f expected => desired` を使用できます。

関連項目: [`replacefield!`](@ref Core.replacefield!) [`setproperty!`](@ref Base.setproperty!)、[`setpropertyonce!`](@ref Base.setpropertyonce!)。
