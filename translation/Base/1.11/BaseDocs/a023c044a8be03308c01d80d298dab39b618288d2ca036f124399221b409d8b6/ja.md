```
swapglobal!(module::Module, name::Symbol, x, [order::Symbol=:monotonic])
```

原子的に操作を実行して、グローバルを同時に取得して設定します。

!!! compat "Julia 1.11"
    この関数はJulia 1.11以降が必要です。


他に[`swapproperty!`](@ref Base.swapproperty!)や[`setglobal!`](@ref)も参照してください。
