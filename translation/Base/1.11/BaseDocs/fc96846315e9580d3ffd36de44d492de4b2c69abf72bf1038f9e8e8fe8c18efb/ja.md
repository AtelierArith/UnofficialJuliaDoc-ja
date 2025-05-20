```
Core.memoryrefset!(::GenericMemoryRef, value, ordering::Symbol, boundscheck::Bool)
```

`MemoryRef`に値を格納し、`Memory`が空の場合は`BoundsError`をスローします。`ref[] = value`を参照してください。指定されたメモリ順序は、`isatomic`パラメータと互換性がある必要があります。

!!! compat "Julia 1.11"
    この関数はJulia 1.11以降が必要です。

