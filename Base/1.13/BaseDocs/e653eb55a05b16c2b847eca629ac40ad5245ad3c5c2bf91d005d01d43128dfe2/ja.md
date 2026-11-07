```julia
Core.memoryrefsetonce!(::GenericMemoryRef, value,
                       success_order::Symbol, fail_order::Symbol=success_order, boundscheck::Bool) -> success::Bool
```

`MemoryRef`を、以前に設定されていない場合に限り、指定した値に設定する操作をアトミックに実行します。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11以降が必要です。


[`setpropertyonce!`](@ref Base.replaceproperty!)および[`Core.memoryrefset!`](@ref)も参照してください。
