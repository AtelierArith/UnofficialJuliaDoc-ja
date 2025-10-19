```julia
end
```

`end` は、[`module`](@ref)、[`struct`](@ref)、[`mutable struct`](@ref)、[`begin`](@ref)、[`let`](@ref)、[`for`](@ref) などの式のブロックの結論を示します。

`end` は、インデックス指定時にコレクションの最後のインデックスや配列の次元の最後のインデックスを表すためにも使用されます。

# 例

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
