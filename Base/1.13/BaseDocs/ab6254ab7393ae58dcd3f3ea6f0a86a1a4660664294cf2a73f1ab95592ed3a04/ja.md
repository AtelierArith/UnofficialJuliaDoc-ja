```julia
Core.memoryrefnew(::GenericMemory)
Core.memoryrefnew(::GenericMemoryRef, index::Int, [boundscheck::Bool])
```

`GenericMemoryRef`を返す`GenericMemory`です。[`memoryref`](@ref)を参照してください。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11以降が必要です。

