```
setglobalonce!(module::Module, name::Symbol, value,
              [success_order::Symbol, [fail_order::Symbol=success_order]) -> success::Bool
```

与えられた値にグローバルを設定する操作を原子的に実行します。以前に設定されていない場合のみ実行されます。

!!! compat "Julia 1.11"
    この関数はJulia 1.11以降が必要です。


[`setpropertyonce!`](@ref Base.setpropertyonce!) および [`setglobal!`](@ref) も参照してください。
