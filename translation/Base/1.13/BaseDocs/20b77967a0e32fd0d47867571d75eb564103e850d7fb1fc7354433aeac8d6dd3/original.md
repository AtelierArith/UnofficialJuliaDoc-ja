```julia
Core.Intrinsics.pointerref(p::Ptr{T}, i::Int, align::Int)
```

Load a value of type `T` from the address of the `i`th element (1-indexed) starting at `p`. This is equivalent to the C expression `p[i-1]`.

The alignment must be a power of two, or 0, indicating the default alignment for `T`. If `p[i-1]` is out of bounds, invalid, or is not aligned, the behavior is undefined. An alignment of 1 is always safe.

See also [`unsafe_load`](@ref).
