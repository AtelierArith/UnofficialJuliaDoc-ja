```
replaceproperty!(x, f::Symbol, expected, desired, success_order::Symbol=:not_atomic, fail_order::Symbol=success_order)
```

`x.f`の値を`expected`から`desired`に、egalに従って比較と入れ替えの操作を行います。関数呼び出しの代わりに、`@atomicreplace x.f expected => desired`という構文を使用できます。

他にも[`replacefield!`](@ref Core.replacefield!)、[`setproperty!`](@ref Base.setproperty!)、[`setpropertyonce!`](@ref Base.setpropertyonce!)を参照してください。
