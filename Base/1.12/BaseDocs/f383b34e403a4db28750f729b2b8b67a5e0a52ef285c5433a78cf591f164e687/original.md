```julia
StridedArray{T, N}
```

A hard-coded [`Union`](@ref) of common array types that follow the [strided array interface](@ref man-interface-strided-arrays), with elements of type `T` and `N` dimensions.

If `A` is a `StridedArray`, then its elements are stored in memory with offsets, which may vary between dimensions but are constant within a dimension. For example, `A` could have stride 2 in dimension 1, and stride 3 in dimension 2. Incrementing `A` along dimension `d` jumps in memory by [`stride(A, d)`] slots. Strided arrays are particularly important and useful because they can sometimes be passed directly as pointers to foreign language libraries like BLAS.
