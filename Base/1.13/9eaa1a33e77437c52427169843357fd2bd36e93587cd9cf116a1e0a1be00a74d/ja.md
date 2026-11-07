```julia
findfirst(predicate::Function, A)
```

`A`の最初の要素のうち、`predicate`が`true`を返す要素のインデックスまたはキーを返します。そのような要素がない場合は、`nothing`を返します。

インデックスまたはキーの型は、[`keys(A)`](@ref)および[`pairs(A)`](@ref)が返す型と同じです。

# Examples

```jldoctest
julia> A = [1, 4, 2, 2]
4-element Vector{Int64}:
 1
 4
 2
 2

julia> findfirst(iseven, A)
2

julia> findfirst(x -> x>10, A) # returns nothing, but not printed in the REPL

julia> findfirst(isequal(4), A)
2

julia> A = [1 4; 2 2]
2×2 Matrix{Int64}:
 1  4
 2  2

julia> findfirst(iseven, A)
CartesianIndex(2, 1)
```
