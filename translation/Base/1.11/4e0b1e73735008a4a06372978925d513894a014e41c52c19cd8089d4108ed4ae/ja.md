```
append!(collection, collections...) -> collection.
```

順序付きコンテナ `collection` に、各 `collections` の要素をその末尾に追加します。

!!! compat "Julia 1.6"
    複数のコレクションを追加するには、少なくとも Julia 1.6 が必要です。


# 例

```jldoctest
julia> append!([1], [2, 3])
3-element Vector{Int64}:
 1
 2
 3

julia> append!([1, 2, 3], [4, 5], [6])
6-element Vector{Int64}:
 1
 2
 3
 4
 5
 6
```

[`push!`](@ref) を使用して、他のコレクションにすでに含まれていない個々のアイテムを `collection` に追加します。前の例の結果は `push!([1, 2, 3], 4, 5, 6)` と同等です。

パフォーマンスモデルに関する注意については、[`sizehint!`](@ref) を参照してください。

ベクトルについては [`vcat`](@ref)、集合については [`union!`](@ref)、逆の順序については [`prepend!`](@ref) と [`pushfirst!`](@ref) も参照してください。
