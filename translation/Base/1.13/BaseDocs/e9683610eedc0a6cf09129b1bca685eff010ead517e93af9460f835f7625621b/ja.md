```julia
Core.memoryrefget(::GenericMemoryRef, ordering::Symbol, boundscheck::Bool)
```

`MemoryRef`に格納されている値を返します。`Memory`が空の場合は、`BoundsError`をスローします。`ref[]`を参照してください。指定するメモリ順序は、`isatomic`パラメーターと互換性がなければなりません。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11以降が必要です。

