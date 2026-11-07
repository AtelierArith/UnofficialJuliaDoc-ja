```julia
∉(item, collection)::Bool
∌(collection, item)::Bool
```

`∈`および`∋`の否定、つまり、`item`が`collection`に含まれていないことを確認します。

`items .∉ collection`でブロードキャストすると、`items`と`collection`の両方がブロードキャストされますが、これは意図した動作でないことがよくあります。たとえば、両方の引数がベクトルで（次元が一致している場合）、結果は、コレクション`items`の各値が、`collection`の対応する位置にある値に含まれていないかどうかを示すベクトルになります。`items`の各値が`collection`に含まれていないかどうかを示すベクトルを得るには、次のように`collection`をタプルまたは`Ref`で囲みます。`items .∉ Ref(collection)`。

# Examples

```jldoctest
julia> 1 ∉ 2:4
true

julia> 1 ∉ 1:3
false

julia> [1, 2] .∉ [2, 3]
2-element BitVector:
 1
 1

julia> [1, 2] .∉ ([2, 3],)
2-element BitVector:
 1
 0
```
