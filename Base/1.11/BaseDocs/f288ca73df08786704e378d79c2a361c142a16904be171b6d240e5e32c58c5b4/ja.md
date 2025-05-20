```
Core.memoryrefmodify!(::GenericMemoryRef, op, value, ordering::Symbol, boundscheck::Bool) -> Pair
```

アトミックに操作を実行して、関数 `op` を適用した後に `MemoryRef` の値を取得して設定します。

!!! compat "Julia 1.11"
    この関数は Julia 1.11 以降が必要です。


他にも [`modifyproperty!`](@ref Base.modifyproperty!) と [`Core.memoryrefset!`](@ref) を参照してください。
