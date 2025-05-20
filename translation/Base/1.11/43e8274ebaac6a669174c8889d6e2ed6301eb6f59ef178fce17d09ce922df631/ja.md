```
AtomicMemory{T} == GenericMemory{:atomic, T, Core.CPU}
```

固定サイズの [`DenseVector{T}`](@ref DenseVector)。その要素へのアクセスは原子的に行われます（`:monotonic` 順序で）。要素の設定は `@atomic` マクロを使用し、明示的に順序を指定する必要があります。

!!! warning
    各要素はアクセス時に独立して原子的であり、非原子的に設定することはできません。現在、`@atomic` マクロと高レベルインターフェースは完成していませんが、将来の実装のための基本的な構成要素として、内部のイントリンシック `Core.memoryrefget`、`Core.memoryrefset!`、`Core.memoryref_isassigned`、`Core.memoryrefswap!`、`Core.memoryrefmodify!`、および `Core.memoryrefreplace!` があります。


詳細については、[Atomic Operations](@ref man-atomic-operations)を参照してください。

!!! compat "Julia 1.11"
    この型は Julia 1.11 以降が必要です。

