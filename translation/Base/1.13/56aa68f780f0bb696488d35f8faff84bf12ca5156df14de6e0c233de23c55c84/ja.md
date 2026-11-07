```julia
Base.rest(collection[, itr_state])
```

特定の反復状態 `itr_state` から始まる、`collection` の末尾を取得する汎用関数です。`collection` 自体が `AbstractVector` のサブタイプである `Tuple` の場合は `Tuple` を返します。`collection` が `AbstractString` のサブタイプである `AbstractArray` の場合は `collection` が `AbstractString` であれば `Iterators.rest(collection[, itr_state])` を返し、それ以外の場合は任意のイテレータを返します。

ユーザー定義のコレクション型では、[slurping in assignments](@ref destructuring-assignment) を最後の位置で使う場合の動作を、`a, b... = collection` のようにカスタマイズするため、オーバーロードできます。

!!! compat "Julia 1.6"
    `Base.rest` には Julia 1.6 以降が必要です。


関連項目: [`first`](@ref first)、[`Iterators.rest`](@ref)、[`Base.split_rest`](@ref)。

# Examples

```jldoctest
julia> a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> first, state = iterate(a)
(1, 2)

julia> first, Base.rest(a, state)
(1, [3, 2, 4])
```
