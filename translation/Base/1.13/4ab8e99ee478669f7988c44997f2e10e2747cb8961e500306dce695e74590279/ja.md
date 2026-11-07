```julia
findmin(itr) -> (x, index)
```

コレクション `itr` の最小要素と、そのインデックスまたはキーを返します。最小要素が複数ある場合は、最初の要素を返します。`NaN` は、`missing` を除くすべての値より小さいものとして扱われます。

インデックスの型は、[`keys(itr)`](@ref) および [`pairs(itr)`](@ref) が返す型と同じです。

関連項目: [`findmax`](@ref)、[`argmin`](@ref)、[`minimum`](@ref)。

# Examples

```jldoctest
julia> findmin([8, 0.1, -9, pi])
(-9.0, 3)

julia> findmin([1, 7, 7, 6])
(1, 1)

julia> findmin([1, 7, 7, NaN])
(NaN, 4)
```
