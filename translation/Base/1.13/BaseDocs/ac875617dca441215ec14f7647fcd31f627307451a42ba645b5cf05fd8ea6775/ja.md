```julia
Core.memoryrefmodify!(::GenericMemoryRef, op, value, ordering::Symbol, boundscheck::Bool)::Pair
```

関数 `op` を適用した後、`MemoryRef` の値を取得して設定する操作をアトミックに実行します。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。


[`modifyproperty!`](@ref Base.modifyproperty!) および [`Core.memoryrefset!`](@ref) も参照してください。
