```julia
Core.memoryrefsetonce!(::GenericMemoryRef, value,
                       success_order::Symbol, fail_order::Symbol=success_order, boundscheck::Bool) -> success::Bool
```

与えられた値に `MemoryRef` を設定する操作を原子的に実行します。これは、以前に設定されていなかった場合のみ行われます。

!!! compat "Julia 1.11"
    この関数は、Julia 1.11 以降が必要です。


関連情報として [`setpropertyonce!`](@ref Base.replaceproperty!) と [`Core.memoryrefset!`](@ref) を参照してください。
