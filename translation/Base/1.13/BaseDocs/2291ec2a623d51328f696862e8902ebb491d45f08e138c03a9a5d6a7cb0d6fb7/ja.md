```julia
Core.memoryrefswap!(::GenericMemoryRef, value, ordering::Symbol, boundscheck::Bool)
```

`MemoryRef` の値を取得すると同時に設定する操作を、アトミックに実行します。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。


関連項目: [`swapproperty!`](@ref Base.swapproperty!)、[`Core.memoryrefset!`](@ref)。
