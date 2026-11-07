```julia
findnext(A, i)
```

`i`以降（またはそれを含む位置）で、`A`型の要素のうち、`true`を満たす次のインデックスを返します。見つからない場合は`nothing`を返します。

インデックスの型は、[`keys(A)`](@ref)および[`pairs(A)`](@ref)が返すものと同じです。

# Examples

```jldoctest
julia> A = [false, false, true, false]
4-element Vector{Bool}:
 0
 0
 1
 0

julia> findnext(A, 1)
3

julia> findnext(A, 4) # returns nothing, but not printed in the REPL

julia> A = [false false; true false]
2×2 Matrix{Bool}:
 0  0
 1  0

julia> findnext(A, CartesianIndex(1, 1))
CartesianIndex(2, 1)
```
