```julia
cconvert(T,x)
```

Convert `x` to a value to be passed to C code as type `T`, typically by calling `convert(T, x)`.

In cases where `x` cannot be safely converted to `T`, unlike [`convert`](@ref), `cconvert` may return an object of a type different from `T`, which however is suitable for [`unsafe_convert`](@ref) to handle. The result of this function should be kept valid (for the GC) until the result of [`unsafe_convert`](@ref) is not needed anymore. This can be used to allocate memory that will be accessed by the `ccall`. If multiple objects need to be allocated, a tuple of the objects can be used as return value.

Neither `convert` nor `cconvert` should take a Julia object and turn it into a `Ptr`.
