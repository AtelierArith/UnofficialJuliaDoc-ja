```julia
in(item, collection)::Bool
∈(item, collection)::Bool
```

指定されたコレクションを反復して生成される値のいずれかに[`==`](@ref)かどうかを判定します。中置記法でも同様に使用できます。

```julia
item in collection
item ∈ collection
```

`Bool`の値を返します。ただし、`item`が[`missing`](@ref)である場合、または`collection`に`missing`が含まれ、`item`は含まれない場合は、`missing`を返します（[three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic)。[`any`](@ref)および[`==`](@ref)と同じ動作です）。コレクションによっては、定義が少し異なります。たとえば、[`Set`](@ref)では、項目がいずれかの要素に[`isequal`](@ref)かどうかを調べます。[`Dict`](@ref)では`key=>value`のペアを検索し、`key`は[`isequal`](@ref)を使って比較します。

辞書にキーが存在するかどうかを調べるには、[`haskey`](@ref)または`k in keys(dict)`を使用してください。上記のコレクションでは、結果は常に`Bool`です。

`in.(items, collection)`または`items .∈ collection`でブロードキャストすると、`items`と`collection`の両方がブロードキャストされますが、これは意図した動作でないことがよくあります。たとえば、両方の引数がベクトルで（次元が一致している場合）、コレクション`items`の各値が、`collection`の対応する位置にある値に`in`かどうかを示すベクトルが返されます。`items`の各値が`collection`に含まれるかどうかを示すベクトルを得るには、次のように`collection`をタプルまたは`Ref`で囲みます。`in.(items, Ref(collection))`または`items .∈ Ref(collection)`。

関連項目：[`∉`](@ref)、[`insorted`](@ref)、[`contains`](@ref)、[`occursin`](@ref)、[`issubset`](@ref)。

# Examples

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
