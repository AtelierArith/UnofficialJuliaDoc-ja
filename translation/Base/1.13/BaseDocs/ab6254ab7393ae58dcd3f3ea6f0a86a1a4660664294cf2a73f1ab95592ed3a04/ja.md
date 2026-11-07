```julia
Core.memoryrefnew(::GenericMemory)
Core.memoryrefnew(::GenericMemoryRef, index::Int, [boundscheck::Bool])
```

`GenericMemoryRef` を `GenericMemory` に対して返します。[`memoryref`](@ref) を参照してください。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。

