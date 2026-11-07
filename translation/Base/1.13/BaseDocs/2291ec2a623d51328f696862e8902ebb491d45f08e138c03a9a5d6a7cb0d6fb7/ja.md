```julia
Core.memoryrefswap!(::GenericMemoryRef, value, ordering::Symbol, boundscheck::Bool)
```

`MemoryRef` の値を取得すると同時に設定する操作を、アトミックに実行します。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。


[`swapproperty!`](@ref Base.swapproperty!) および [`Core.memoryrefset!`](@ref) も参照してください。
