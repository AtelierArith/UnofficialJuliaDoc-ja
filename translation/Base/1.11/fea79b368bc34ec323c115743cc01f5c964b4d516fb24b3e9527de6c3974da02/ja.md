```
push!(collection, items...) -> collection
```

1つ以上の`items`を`collection`に挿入します。`collection`が順序付きコンテナである場合、アイテムは最後に（指定された順序で）挿入されます。

# 例

```jldoctest
julia> push!([1, 2, 3], 4, 5, 6)
6-element Vector{Int64}:
 1
 2
 3
 4
 5
 6
```

`collection`が順序付きである場合、[`append!`](@ref)を使用して別のコレクションのすべての要素を追加できます。前の例の結果は、`append!([1, 2, 3], [4, 5, 6])`と同等です。`AbstractSet`オブジェクトの場合は、[`union!`](@ref)を代わりに使用できます。

パフォーマンスモデルに関する注意については、[`sizehint!`](@ref)を参照してください。

また、[`pushfirst!`](@ref)も参照してください。
