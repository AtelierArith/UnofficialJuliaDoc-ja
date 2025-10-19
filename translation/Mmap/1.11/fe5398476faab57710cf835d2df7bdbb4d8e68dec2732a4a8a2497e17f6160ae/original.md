```julia
mmap(io, BitArray, [dims, offset])
```

Create a [`BitArray`](@ref) whose values are linked to a file, using memory-mapping; it has the same purpose, works in the same way, and has the same arguments, as [`mmap`](@ref mmap), but the byte representation is different.

# Examples

```jldoctest
julia> using Mmap

julia> io = open("mmap.bin", "w+");

julia> B = mmap(io, BitArray, (25,30000));

julia> B[3, 4000] = true;

julia> Mmap.sync!(B);

julia> close(io);

julia> io = open("mmap.bin", "r+");

julia> C = mmap(io, BitArray, (25,30000));

julia> C[3, 4000]
true

julia> C[2, 4000]
false

julia> close(io)

julia> rm("mmap.bin")
```

This creates a 25-by-30000 `BitArray`, linked to the file associated with stream `io`.
