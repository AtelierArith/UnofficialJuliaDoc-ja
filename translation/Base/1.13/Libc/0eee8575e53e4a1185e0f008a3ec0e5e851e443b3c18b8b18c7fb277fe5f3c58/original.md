```julia
free(addr::Ptr)
```

Call `free` from the C standard library. Only use this on memory obtained from [`malloc`](@ref), not on pointers retrieved from other C libraries. [`Ptr`](@ref) objects obtained from C libraries should be freed by the free functions defined in that library, to avoid assertion failures if multiple `libc` libraries exist on the system.
