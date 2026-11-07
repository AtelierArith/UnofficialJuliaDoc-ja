```julia
end
```

`end` は、たとえば [`module`](@ref)、[`struct`](@ref)、[`mutable struct`](@ref)、[`begin`](@ref)、[`let`](@ref)、[`for`](@ref) などの式のブロックの終わりを示します。

`end` は、コレクションの最後のインデックスや、配列の次元の最後のインデックスを表すために、インデックス指定で使われることもあります。

# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> A[end, :]
2-element Vector{Int64}:
 3
 4
```
