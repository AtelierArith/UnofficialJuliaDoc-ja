```julia
argmax(itr)
```

コレクション内の最大要素のインデックスまたはキーを返します。最大要素が複数ある場合は、最初の要素を返します。

コレクションは空であってはなりません。

インデックスの型は、[`keys(itr)`](@ref)および[`pairs(itr)`](@ref)が返す型と同じです。

値は`isless`で比較されます。

関連項目: [`argmin`](@ref)、[`findmax`](@ref)。

# Examples

```jldoctest
julia> argmax([8, 0.1, -9, pi])
1

julia> argmax([1, 7, 7, 6])
2

julia> argmax([1, 7, 7, NaN])
4
```
