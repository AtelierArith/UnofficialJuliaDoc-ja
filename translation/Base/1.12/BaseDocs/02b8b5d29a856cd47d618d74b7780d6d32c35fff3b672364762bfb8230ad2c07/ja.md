```julia
setproperty!(value, name::Symbol, x)
setproperty!(value, name::Symbol, x, order::Symbol)
```

構文 `a.b = c` は `setproperty!(a, :b, c)` を呼び出します。構文 `@atomic order a.b = c` は `setproperty!(a, :b, c, :order)` を呼び出し、構文 `@atomic a.b = c` は `setproperty!(a, :b, c, :sequentially_consistent)` を呼び出します。

!!! compat "Julia 1.8"
    モジュールでの `setproperty!` は少なくとも Julia 1.8 が必要です。


他に [`setfield!`](@ref Core.setfield!), [`propertynames`](@ref Base.propertynames) および [`getproperty`](@ref Base.getproperty) を参照してください。
