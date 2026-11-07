```julia
Base.split_rest(collection, n::Int[, itr_state]) -> (rest_but_n, last_n)
```

`collection` の末尾を、特定の反復状態 `itr_state` から分割する汎用関数です。新しいコレクションを2つ含むタプルを返します。1つ目には末尾の要素のうち、最後の `n` 個を除いたすべてが含まれ、残りの要素は2つ目のコレクションに格納されます。

1つ目のコレクションの型は、通常 [`Base.rest`](@ref) の型に従います。ただし、フォールバックの場合は遅延評価されず、ベクターに即時収集されます。

ユーザー定義のコレクション型でオーバーロードして、[slurping in assignments](@ref destructuring-assignment) が末尾以外の位置にある場合の動作（たとえば `a, b..., c = collection`）をカスタマイズできます。

!!! compat "Julia 1.9"
    `Base.split_rest` には Julia 1.9 以降が必要です。


関連項目: [`Base.rest`](@ref)。

# Examples

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
