```julia
resize_nthreads!(A, copyvalue=A[1])
```

Resize the array `A` to length [`nthreads()`](@ref).   Any new elements that are allocated are initialized to `deepcopy(copyvalue)`, where `copyvalue` defaults to `A[1]`.

This is typically used to allocate per-thread variables, and should be called in `__init__` if `A` is a global constant.

!!! warning
    This function is deprecated, since as of Julia v1.9 the number of threads can change at run time. Instead, per-thread state should be created as needed based on the thread id of the caller.

