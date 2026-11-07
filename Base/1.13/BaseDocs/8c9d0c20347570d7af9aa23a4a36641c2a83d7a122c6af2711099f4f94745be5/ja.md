```julia
Core.memoryrefreplace!(::GenericMemoryRef, expected, desired,
                       success_order::Symbol, fail_order::Symbol=success_order, boundscheck::Bool) -> (; old, success::Bool)
```

値を取得し、条件に応じて設定する操作をアトミックに実行します。`MemoryRef`

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。


関連項目: [`replaceproperty!`](@ref Base.replaceproperty!) および [`Core.memoryrefset!`](@ref)。
