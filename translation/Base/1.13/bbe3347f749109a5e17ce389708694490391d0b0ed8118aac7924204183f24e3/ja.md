```julia
append!(collection, collections...) -> collection.
```

順序付きコンテナ `collection` に、各 `collections` の要素を追加します。

!!! compat "Julia 1.6"
    複数のコレクションを追加するには、Julia 1.6 以降が必要です。


# Examples

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

別のコレクションに含まれていない個々の要素を `collection` に追加するには、[`push!`](@ref) を使用します。先ほどの例の結果は、`push!([1, 2, 3], 4, 5, 6)` と同等です。

パフォーマンスモデルについては [`sizehint!`](@ref) を参照してください。

ベクトルについては [`vcat`](@ref)、集合については [`union!`](@ref)、逆順の操作については [`prepend!`](@ref) および [`pushfirst!`](@ref) も参照してください。
