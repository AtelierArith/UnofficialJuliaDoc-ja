```julia
LLVMPtr{T, AS}
```

A pointer type that more closely resembles LLVM semantics: It includes the pointer address space, and will be passed as an actual pointer instead of an integer.

This type is mainly used to interface with code that has strict requirements about pointers, e.g., intrinsics that are selected based on the address space, or back-ends that require pointers to be identifiable by their types.
