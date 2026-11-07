```julia
memoryref(::GenericMemory, index::Integer)
memoryref(::GenericMemoryRef, index::Integer)
```

Construct a `GenericMemoryRef` from a memory object and an offset index (1-based) which can also be negative. This always returns an inbounds object, and will throw an error if that is not possible (because the index would result in a shift out-of-bounds of the underlying memory).
