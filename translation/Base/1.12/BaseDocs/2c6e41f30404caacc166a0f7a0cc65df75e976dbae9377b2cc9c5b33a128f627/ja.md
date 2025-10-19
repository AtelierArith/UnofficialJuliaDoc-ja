```julia
Core.memoryrefreplace!(::GenericMemoryRef, expected, desired,
                       success_order::Symbol, fail_order::Symbol=success_order, boundscheck::Bool) -> (; old, success::Bool)
```

アトミックに操作を実行して、`MemoryRef` 値を取得し、条件付きで設定します。

!!! compat "Julia 1.11"
    この関数は Julia 1.11 以降が必要です。


関連情報として [`replaceproperty!`](@ref Base.replaceproperty!) と [`Core.memoryrefset!`](@ref) を参照してください。
