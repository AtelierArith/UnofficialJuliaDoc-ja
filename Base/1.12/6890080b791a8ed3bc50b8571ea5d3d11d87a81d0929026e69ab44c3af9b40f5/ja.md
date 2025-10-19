```julia
findfirst(A)
```

`A`の最初の`true`値のインデックスまたはキーを返します。そのような値が見つからない場合は`nothing`を返します。他の種類の値を検索するには、最初の引数として述語を渡します。

インデックスまたはキーは、[`keys(A)`](@ref)および[`pairs(A)`](@ref)によって返されるものと同じ型です。

他にも: [`findall`](@ref), [`findnext`](@ref), [`findlast`](@ref), [`searchsortedfirst`](@ref).

# 例

```jldoctest
julia> A = [false, false, true, false]
4-element Vector{Bool}:
 0
 0
 1
 0

julia> findfirst(A)
3

julia> findfirst(falses(3)) # 何も返さないが、REPLには表示されない

julia> A = [false false; true false]
2×2 Matrix{Bool}:
 0  0
 1  0

julia> findfirst(A)
CartesianIndex(2, 1)
```
