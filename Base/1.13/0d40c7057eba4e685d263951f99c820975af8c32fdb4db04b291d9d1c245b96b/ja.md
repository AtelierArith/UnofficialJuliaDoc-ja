```julia
argmin(itr)
```

コレクション内の最小要素のインデックスまたはキーを返します。最小要素が複数ある場合は、最初の要素が返されます。

コレクションは空であってはなりません。

インデックスの型は、[`keys(itr)`](@ref)および[`pairs(itr)`](@ref)が返す型と同じです。

`NaN`は、`missing`を除くすべての値より小さいものとして扱われます。

関連項目: [`argmax`](@ref)、[`findmin`](@ref)。

# Examples

```jldoctest
julia> argmin([8, 0.1, -9, pi])
3

julia> argmin([7, 1, 1, 6])
2

julia> argmin([7, 1, 1, NaN])
4
```
