```
in(item, collection) -> Bool
∈(item, collection) -> Bool
```

指定されたコレクションにアイテムが含まれているかどうかを判断します。これは、コレクションを反復処理して生成された値のいずれかに対して[`==`](@ref)であるという意味です。`item`が[`missing`](@ref)であるか、`collection`が`item`を含まない`missing`を含む場合を除いて、`Bool`値を返します。この場合、`missing`が返されます（[三値論理](https://en.wikipedia.org/wiki/Three-valued_logic)、[`any`](@ref)および[`==`](@ref)の動作に一致します）。

一部のコレクションは、わずかに異なる定義に従います。たとえば、[`Set`](@ref)はアイテムが要素のいずれかに[`isequal`](@ref)であるかどうかを確認します。[`Dict`](@ref)は`key=>value`ペアを探し、`key`は[`isequal`](@ref)を使用して比較されます。

辞書内のキーの存在をテストするには、[`haskey`](@ref)または`k in keys(dict)`を使用します。上記のコレクションについては、結果は常に`Bool`です。

`in.(items, collection)`または`items .∈ collection`でブロードキャストすると、`item`と`collection`の両方がブロードキャストされますが、これはしばしば意図したものではありません。たとえば、両方の引数がベクトルで（次元が一致する場合）、結果はコレクション`items`の各値が`collection`の対応する位置の値に`in`であるかどうかを示すベクトルになります。`items`の各値が`collection`に含まれているかどうかを示すベクトルを取得するには、`collection`をタプルまたは`Ref`でラップします。次のようにします：`in.(items, Ref(collection))`または`items .∈ Ref(collection)`。

関連情報：[`∉`](@ref)、[`insorted`](@ref)、[`contains`](@ref)、[`occursin`](@ref)、[`issubset`](@ref)。

# 例

```jldoctest
julia> a = 1:3:20
1:3:19

julia> 4 in a
true

julia> 5 in a
false

julia> missing in [1, 2]
missing

julia> 1 in [2, missing]
missing

julia> 1 in [1, missing]
true

julia> missing in Set([1, 2])
false

julia> (1=>missing) in Dict(1=>10, 2=>20)
missing

julia> [1, 2] .∈ [2, 3]
2-element BitVector:
 0
 0

julia> [1, 2] .∈ ([2, 3],)
2-element BitVector:
 0
 1
```
