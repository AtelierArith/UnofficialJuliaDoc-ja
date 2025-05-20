```
AtomicMemory{T} == GenericMemory{:atomic, T, Core.CPU}
```

Fixed-size [`DenseVector{T}`](@ref DenseVector). Access to its any of its elements is performed atomically (with `:monotonic` ordering). Setting any of the elements must be accomplished using the `@atomic` macro and explicitly specifying ordering.

!!! warning
    Each element is independently atomic when accessed, and cannot be set non-atomically. Currently the `@atomic` macro and higher level interface have not been completed, but the building blocks for a future implementation are the internal intrinsics `Core.memoryrefget`, `Core.memoryrefset!`, `Core.memoryref_isassigned`, `Core.memoryrefswap!`, `Core.memoryrefmodify!`, and `Core.memoryrefreplace!`.


For details, see [Atomic Operations](@ref man-atomic-operations)

!!! compat "Julia 1.11"
    This type requires Julia 1.11 or later.

