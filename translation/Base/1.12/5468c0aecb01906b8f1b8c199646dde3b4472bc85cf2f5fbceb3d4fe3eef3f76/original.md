```julia
BitArray(undef, dims::Integer...)
BitArray{N}(undef, dims::NTuple{N,Int})
```

Construct an undef [`BitArray`](@ref) with the given dimensions. Behaves identically to the [`Array`](@ref) constructor. See [`undef`](@ref).

# Examples

```julia-repl
julia> BitArray(undef, 2, 2)
2×2 BitMatrix:
 0  0
 0  0

julia> BitArray(undef, (3, 1))
3×1 BitMatrix:
 0
 0
 0
```
