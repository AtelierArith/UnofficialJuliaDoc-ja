```julia
findprev(A, i)
```

`A`の`true`要素の`i`の前または`i`を含む前のインデックスを見つける。見つからない場合は`nothing`を返す。

インデックスは[`keys(A)`](@ref)および[`pairs(A)`](@ref)によって返されるものと同じ型である。

関連: [`findnext`](@ref), [`findfirst`](@ref), [`findall`](@ref)。

# 例

```jldoctest
julia> A = [false, false, true, true]
4-element Vector{Bool}:
 0
 0
 1
 1

julia> findprev(A, 3)
3

julia> findprev(A, 1) # nothingを返すが、REPLには表示されない

julia> A = [false false; true true]
2×2 Matrix{Bool}:
 0  0
 1  1

julia> findprev(A, CartesianIndex(2, 1))
CartesianIndex(2, 1)
```
