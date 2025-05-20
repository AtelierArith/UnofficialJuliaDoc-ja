```
replaceglobal!(module::Module, name::Symbol, expected, desired,
              [success_order::Symbol, [fail_order::Symbol=success_order]) -> (; old, success::Bool)
```

原子操作を実行して、グローバルを指定された値に条件付きで設定します。

!!! compat "Julia 1.11"
    この関数はJulia 1.11以降が必要です。


他に[`replaceproperty!`](@ref Base.replaceproperty!)や[`setglobal!`](@ref)も参照してください。
