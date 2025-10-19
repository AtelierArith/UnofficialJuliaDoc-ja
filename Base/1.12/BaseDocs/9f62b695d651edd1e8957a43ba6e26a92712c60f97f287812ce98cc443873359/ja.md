```julia
Core.memoryref_isassigned(::GenericMemoryRef, ordering::Symbol, boundscheck::Bool)
```

`MemoryRef`に値が格納されているかどうかを返し、`Memory`が空の場合はfalseを返します。 [`isassigned(::Base.RefValue)`](@ref)、[`Core.memoryrefget`](@ref)を参照してください。指定されたメモリ順序は、`isatomic`パラメータと互換性がある必要があります。

!!! compat "Julia 1.11"
    この関数はJulia 1.11以降が必要です。

