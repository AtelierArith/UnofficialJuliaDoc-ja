```julia
Core.memoryrefset!(::GenericMemoryRef, value, ordering::Symbol, boundscheck::Bool)
```

値を`MemoryRef`に格納します。`Memory`が空の場合は、`BoundsError`をスローします。詳細は`ref[] = value`を参照してください。指定するメモリ順序は、`isatomic`パラメーターと互換性がなければなりません。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11以降が必要です。

