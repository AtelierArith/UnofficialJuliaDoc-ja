```julia
Core.memoryrefmodify!(::GenericMemoryRef, op, value, ordering::Symbol, boundscheck::Bool)::Pair
```

関数 `op` を適用した値 `MemoryRef` の取得と設定を、アトミックに実行します。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。


関連項目: [`modifyproperty!`](@ref Base.modifyproperty!) および [`Core.memoryrefset!`](@ref)。
