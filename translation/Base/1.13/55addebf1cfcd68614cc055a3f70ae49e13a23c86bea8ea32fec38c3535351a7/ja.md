```julia
findlast(A)
```

`A` 内の最後の `true` の値のインデックスまたはキーを返します。`A` に `true` の値がない場合は、`nothing` を返します。

インデックスまたはキーの型は、[`keys(A)`](@ref) および [`pairs(A)`](@ref) が返す型と同じです。

関連項目: [`findfirst`](@ref)、[`findprev`](@ref)、[`findall`](@ref)。

# Examples

```jldoctest
julia> A = [true, false, true, false]
4-element Vector{Bool}:
 1
 0
 1
 0

julia> findlast(A)
3

julia> A = falses(2,2);

julia> findlast(A) # returns nothing, but not printed in the REPL

julia> A = [true false; true false]
2×2 Matrix{Bool}:
 1  0
 1  0

julia> findlast(A)
CartesianIndex(2, 1)
```
