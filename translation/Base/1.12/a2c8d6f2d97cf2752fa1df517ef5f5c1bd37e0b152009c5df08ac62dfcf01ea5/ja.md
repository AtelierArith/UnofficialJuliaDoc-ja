```julia
Base.split_rest(collection, n::Int[, itr_state]) -> (rest_but_n, last_n)
```

コレクションの末尾を特定のイテレーション状態 `itr_state` から分割するための汎用関数。2つの新しいコレクションのタプルを返します。最初のコレクションには末尾のすべての要素が含まれますが、`n` 個の最後の要素は含まれず、これが2番目のコレクションを構成します。

最初のコレクションの型は一般的に [`Base.rest`](@ref) の型に従いますが、フォールバックケースは遅延ではなく、ベクターに即座に収集されます。

ユーザー定義のコレクション型に対してオーバーロードすることができ、非最終位置での [スラープによる代入](@ref destructuring-assignment) の動作をカスタマイズできます。例えば、`a, b..., c = collection` のように。

!!! compat "Julia 1.9"
    `Base.split_rest` は少なくとも Julia 1.9 を必要とします。


参照: [`Base.rest`](@ref).

# 例

```jldoctest
julia> a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> first, state = iterate(a)
(1, 2)

julia> first, Base.split_rest(a, 1, state)
(1, ([3, 2], [4]))
```
