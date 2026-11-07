```julia
findmax(itr) -> (x, index)
```

コレクション `itr` の最大要素と、そのインデックスまたはキーを返します。最大要素が複数ある場合は、最初の要素を返します。値の比較には `isless` を使用します。

インデックスの型は、[`keys(itr)`](@ref) および [`pairs(itr)`](@ref) が返す型と同じです。

関連項目: [`findmin`](@ref)、[`argmax`](@ref)、[`maximum`](@ref)。

# Examples

```jldoctest
julia> findmax([8, 0.1, -9, pi])
(8.0, 1)

julia> findmax([1, 7, 7, 6])
(7, 2)

julia> findmax([1, 7, 7, NaN])
(NaN, 4)
```
