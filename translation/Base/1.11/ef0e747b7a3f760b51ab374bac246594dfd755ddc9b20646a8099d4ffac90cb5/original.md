```
VecElement{T}
```

A wrapper type that holds a single value of type `T`. When used in the context of an `NTuple{N, VecElement{T}} where {T, N}` object, it provides a hint to the runtime system to align that struct to be more amenable to vectorization optimization opportunities. In `ccall`, such an NTuple in the type signature will also use the vector register ABI, rather than the usual struct ABI.
