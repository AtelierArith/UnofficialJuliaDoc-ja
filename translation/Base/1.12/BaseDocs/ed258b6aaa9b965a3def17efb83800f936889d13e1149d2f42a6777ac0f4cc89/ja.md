```julia
Core.memoryrefnew(::GenericMemory)
Core.memoryrefnew(::GenericMemoryRef, index::Int, [boundscheck::Bool])
```

`GenericMemory`のための`GenericMemoryRef`を返します。[`memoryref`](@ref)を参照してください。

!!! compat "Julia 1.11"
    この関数はJulia 1.11以降が必要です。

