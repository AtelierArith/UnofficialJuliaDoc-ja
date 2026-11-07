```julia
pointer(array [, index])
```

Get the native address of an array or string, optionally at a given location `index`.

This function is "unsafe". Be careful to ensure that a Julia reference to `array` exists as long as this pointer will be used. The [`GC.@preserve`](@ref) macro should be used to protect the `array` argument from garbage collection within a given block of code.

Calling [`Ref(array[, index])`](@ref Ref) is generally preferable to this function as it guarantees validity.
