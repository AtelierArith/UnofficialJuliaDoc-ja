```julia
Base.rest(collection[, itr_state])
```

特定の反復状態 `itr_state` から始まる `collection` の残りの部分を取得する汎用関数です。`collection` 自体が `Tuple` であれば `Tuple` を、`collection` が `AbstractArray` であれば `AbstractVector` のサブタイプを、`collection` が `AbstractString` であれば `AbstractString` のサブタイプを返します。それ以外の場合は、`Iterators.rest(collection[, itr_state])` にフォールバックして任意のイテレータを返します。

ユーザー定義のコレクション型に対してオーバーロードすることで、`a, b... = collection` のように末尾に置かれた [slurping in assignments](@ref destructuring-assignment) の動作をカスタマイズできます。

!!! compat "Julia 1.6"
    `Base.rest` には Julia 1.6 以降が必要です。


関連項目: [`first`](@ref first), [`Iterators.rest`](@ref), [`Base.split_rest`](@ref)。

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
