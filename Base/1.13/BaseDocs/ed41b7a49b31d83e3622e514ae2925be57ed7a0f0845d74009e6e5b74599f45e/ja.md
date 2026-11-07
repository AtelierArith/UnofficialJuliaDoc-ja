```julia
setproperty!(value, name::Symbol, x)
setproperty!(value, name::Symbol, x, order::Symbol)
```

`a.b = c` 構文は `setproperty!(a, :b, c)` を呼び出します。`@atomic order a.b = c` 構文は `setproperty!(a, :b, c, :order)` を呼び出し、`@atomic a.b = c` 構文は `setproperty!(a, :b, c, :sequentially_consistent)` を呼び出します。

!!! compat "Julia 1.8"
    モジュールに対する `setproperty!` の使用には、Julia 1.8 以降が必要です。


[`setfield!`](@ref Core.setfield!)、[`propertynames`](@ref Base.propertynames)、[`getproperty`](@ref Base.getproperty) も参照してください。
