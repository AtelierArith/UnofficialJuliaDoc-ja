```
Core.memoryrefget(::GenericMemoryRef, ordering::Symbol, boundscheck::Bool)
```

`MemoryRef`に格納されている値を返します。`Memory`が空の場合は`BoundsError`をスローします。`ref[]`を参照してください。指定されたメモリ順序は、`isatomic`パラメータと互換性がある必要があります。

!!! compat "Julia 1.11"
    この関数はJulia 1.11以降が必要です。

