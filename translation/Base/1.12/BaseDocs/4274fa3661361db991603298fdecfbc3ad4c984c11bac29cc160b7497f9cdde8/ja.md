```julia
Core.memoryrefswap!(::GenericMemoryRef, value, ordering::Symbol, boundscheck::Bool)
```

アトミックに操作を実行して、`MemoryRef` 値を同時に取得して設定します。

!!! compat "Julia 1.11"
    この関数は Julia 1.11 以降が必要です。


他にも [`swapproperty!`](@ref Base.swapproperty!) と [`Core.memoryrefset!`](@ref) を参照してください。
