```julia
findmin(itr) -> (x, index)
```

コレクション `itr` の最小要素とそのインデックスまたはキーを返します。最小要素が複数ある場合は、最初のものが返されます。`NaN` は `missing` を除くすべての値よりも小さいと見なされます。

インデックスは [`keys(itr)`](@ref) および [`pairs(itr)`](@ref) によって返されるものと同じ型です。

関連項目: [`findmax`](@ref), [`argmin`](@ref), [`minimum`](@ref).

# 例

```jldoctest
julia> findmin([8, 0.1, -9, pi])
(-9.0, 3)

julia> findmin([1, 7, 7, 6])
(1, 1)

julia> findmin([1, 7, 7, NaN])
(NaN, 4)
```
