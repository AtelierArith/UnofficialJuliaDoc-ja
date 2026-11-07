```julia
findlast(predicate::Function, A)
```

`predicate` が `true` を返す、`A` の最後の要素のインデックスまたはキーを返します。そのような要素がない場合は、`nothing` を返します。

インデックスまたはキーの型は、[`keys(A)`](@ref) および [`pairs(A)`](@ref) が返す値と同じです。

# Examples

```jldoctest
julia> A = [1, 2, 3, 4]
4-element Vector{Int64}:
 1
 2
 3
 4

julia> findlast(isodd, A)
3

julia> findlast(x -> x > 5, A) # returns nothing, but not printed in the REPL

julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> findlast(isodd, A)
CartesianIndex(2, 1)
```
