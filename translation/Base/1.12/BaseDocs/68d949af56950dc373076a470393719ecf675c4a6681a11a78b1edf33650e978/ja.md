```julia
replaceproperty!(x, f::Symbol, expected, desired, success_order::Symbol=:not_atomic, fail_order::Symbol=success_order)
```

`x.f`の値を`expected`から`desired`に、egalに従って比較交換操作を行います。関数呼び出し形式の代わりに、構文`@atomicreplace x.f expected => desired`を使用できます。

関連項目としては、[`replacefield!`](@ref Core.replacefield!) [`setproperty!`](@ref Base.setproperty!), [`setpropertyonce!`](@ref Base.setpropertyonce!)があります。
