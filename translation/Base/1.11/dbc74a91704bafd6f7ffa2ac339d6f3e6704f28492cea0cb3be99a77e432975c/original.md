```
unsafe_modify!(p::Ptr{T}, op, x, [order::Symbol]) -> Pair
```

These atomically perform the operations to get and set a memory address after applying the function `op`. If supported by the hardware (for example, atomic increment), this may be optimized to the appropriate hardware instruction, otherwise its execution will be similar to:

```
y = unsafe_load(p)
z = op(y, x)
unsafe_store!(p, z)
return y => z
```

The `unsafe` prefix on this function indicates that no validation is performed on the pointer `p` to ensure that it is valid. Like C, the programmer is responsible for ensuring that referenced memory is not freed or garbage collected while invoking this function. Incorrect usage may segfault your program.

!!! compat "Julia 1.10"
    This function requires at least Julia 1.10.


See also: [`modifyproperty!`](@ref Base.modifyproperty!), [`atomic`](@ref)
