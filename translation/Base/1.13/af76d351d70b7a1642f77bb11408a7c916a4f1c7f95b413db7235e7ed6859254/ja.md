```julia
push!(collection, items...) -> collection
```

`collection` に、`items` を1つ以上挿入します。`collection` が順序付きコンテナの場合、要素は指定された順序で末尾に挿入されます。

# Examples

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

`collection` が順序付きの場合、[`append!`](@ref) を使って、別のコレクションのすべての要素を追加します。先ほどの例の結果は、`append!([1, 2, 3], [4, 5, 6])` と同等です。`AbstractSet` オブジェクトには、代わりに [`union!`](@ref) を使用できます。

パフォーマンスモデルについては、[`sizehint!`](@ref) を参照してください。

[`pushfirst!`](@ref) も参照してください。
