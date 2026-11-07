```julia
findfirst(A)
```

`true` の値が `A` 内で最初に見つかった位置のインデックスまたはキーを返します。そのような値が見つからない場合は、`nothing` を返します。他の種類の値を検索するには、述語を第1引数として渡します。

インデックスまたはキーの型は、[`keys(A)`](@ref) および [`pairs(A)`](@ref) が返すものと同じです。

関連項目: [`findall`](@ref)、[`findnext`](@ref)、[`findlast`](@ref)、[`searchsortedfirst`](@ref)。

# Examples

```jldoctest
julia> A = [false, false, true, false]
4-element Vector{Bool}:
 0
 0
 1
 0

julia> findfirst(A)
3

julia> findfirst(falses(3)) # returns nothing, but not printed in the REPL

julia> A = [false false; true false]
2×2 Matrix{Bool}:
 0  0
 1  0

julia> findfirst(A)
CartesianIndex(2, 1)
```
