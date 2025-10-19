```julia
setpropertyonce!(x, f::Symbol, value, success_order::Symbol=:not_atomic, fail_order::Symbol=success_order)
```

`x.f`に対して比較とスワップの操作を行い、以前に設定されていなければ`value`に設定します。関数呼び出し形式の代わりに`@atomiconce x.f = value`という構文を使用できます。

関連情報としては、[`setfieldonce!`](@ref Core.replacefield!), [`setproperty!`](@ref Base.setproperty!), [`replaceproperty!`](@ref Base.replaceproperty!)があります。

!!! compat "Julia 1.11"
    この関数はJulia 1.11以降が必要です。

