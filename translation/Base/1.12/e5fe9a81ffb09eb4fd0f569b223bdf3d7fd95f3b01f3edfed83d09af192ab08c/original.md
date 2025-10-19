```julia
findall(
    pattern::Union{AbstractString,AbstractPattern},
    string::AbstractString;
    overlap::Bool = false,
)
findall(
    pattern::Vector{UInt8}
    A::Vector{UInt8};
    overlap::Bool = false,
)
```

Return a `Vector{UnitRange{Int}}` of all the matches for `pattern` in `string`. Each element of the returned vector is a range of indices where the matching sequence is found, like the return value of [`findnext`](@ref).

If `overlap=true`, the matching sequences are allowed to overlap indices in the original string, otherwise they must be from disjoint character ranges.

# Examples

```jldoctest
julia> findall("a", "apple")
1-element Vector{UnitRange{Int64}}:
 1:1

julia> findall("nana", "banana")
1-element Vector{UnitRange{Int64}}:
 3:6

julia> findall("a", "banana")
3-element Vector{UnitRange{Int64}}:
 2:2
 4:4
 6:6

julia> findall(UInt8[1,2], UInt8[1,2,3,1,2])
2-element Vector{UnitRange{Int64}}:
 1:2
 4:5
```

!!! compat "Julia 1.3"
    This method requires at least Julia 1.3.

