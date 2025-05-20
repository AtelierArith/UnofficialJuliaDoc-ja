```
Base.rest(collection[, itr_state])
```

特定のイテレーション状態 `itr_state` から始めて `collection` の末尾を取得するための汎用関数。`collection` 自体が `Tuple` の場合は `Tuple` を返し、`collection` が `AbstractArray` の場合は `AbstractVector` のサブタイプを返し、`collection` が `AbstractString` の場合は `AbstractString` のサブタイプを返し、それ以外の場合は任意のイテレーターを返し、`Iterators.rest(collection[, itr_state])` にフォールバックします。

ユーザー定義のコレクションタイプに対してオーバーロードすることで、最終位置での [スラープによる代入](@ref destructuring-assignment) の動作をカスタマイズできます。例えば、`a, b... = collection` のように。

!!! compat "Julia 1.6"
    `Base.rest` は少なくとも Julia 1.6 が必要です。


参照: [`first`](@ref first), [`Iterators.rest`](@ref), [`Base.split_rest`](@ref).

# 例

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
