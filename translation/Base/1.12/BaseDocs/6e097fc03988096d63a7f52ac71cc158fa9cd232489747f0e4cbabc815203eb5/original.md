```julia
memoryref(::GenericMemory)
```

Construct a `GenericMemoryRef` from a memory object. This does not fail, but the resulting memory will point out-of-bounds if and only if the memory is empty.
