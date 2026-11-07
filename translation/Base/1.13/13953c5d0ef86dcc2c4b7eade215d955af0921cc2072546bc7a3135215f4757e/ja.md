```julia
findprev(A, i)
```

`i`以前または同じ位置にある、`A`の要素`true`の直前のインデックスを返します。見つからない場合は`nothing`を返します。

インデックスの型は、[`keys(A)`](@ref)および[`pairs(A)`](@ref)が返す型と同じです。

関連項目: [`findnext`](@ref)、[`findfirst`](@ref)、[`findall`](@ref)。

# Examples

```jldoctest
julia> A = [false, false, true, true]
4-element Vector{Bool}:
 0
 0
 1
 1

julia> findprev(A, 3)
3

julia> findprev(A, 1) # returns nothing, but not printed in the REPL

julia> A = [false false; true true]
2×2 Matrix{Bool}:
 0  0
 1  1

julia> findprev(A, CartesianIndex(2, 1))
CartesianIndex(2, 1)
```
