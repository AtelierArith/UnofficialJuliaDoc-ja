```
BitArray{N} <: AbstractArray{Bool, N}
```

Space-efficient `N`-dimensional boolean array, using just one bit for each boolean value.

`BitArray`s pack up to 64 values into every 8 bytes, resulting in an 8x space efficiency over `Array{Bool, N}` and allowing some operations to work on 64 values at once.

By default, Julia returns `BitArrays` from [broadcasting](@ref Broadcasting) operations that generate boolean elements (including dotted-comparisons like `.==`) as well as from the functions [`trues`](@ref) and [`falses`](@ref).

!!! note
    Due to its packed storage format, concurrent access to the elements of a `BitArray` where at least one of them is a write is not thread-safe.

