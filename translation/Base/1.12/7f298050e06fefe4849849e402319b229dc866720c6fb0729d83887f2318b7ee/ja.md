```julia
findfirst(predicate::Function, A)
```

`predicate` が `true` を返す `A` の最初の要素のインデックスまたはキーを返します。そのような要素がない場合は `nothing` を返します。

インデックスまたはキーは、[`keys(A)`](@ref) および [`pairs(A)`](@ref) によって返されるものと同じ型です。

# 例

```jldoctest
julia> A = [1, 4, 2, 2]
4-element Vector{Int64}:
 1
 4
 2
 2

julia> findfirst(iseven, A)
2

julia> findfirst(x -> x>10, A) # nothing を返しますが、REPL には表示されません

julia> findfirst(isequal(4), A)
2

julia> A = [1 4; 2 2]
2×2 Matrix{Int64}:
 1  4
 2  2

julia> findfirst(iseven, A)
CartesianIndex(2, 1)
```
