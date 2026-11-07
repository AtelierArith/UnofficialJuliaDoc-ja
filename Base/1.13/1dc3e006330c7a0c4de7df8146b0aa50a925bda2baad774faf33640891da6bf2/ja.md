```julia
any(p, itr)::Bool
```

述語 `p` が `itr` の要素に対して `true` を返すかどうかを判定します。`itr` の項目のうち、`p` が `true` を返す最初の項目が見つかった時点で、`true` を返します（短絡評価）。`false` で短絡評価するには、[`all`](@ref) を使用してください。

入力に [`missing`](@ref) の値が含まれる場合、欠損値でない値がすべて `false` であれば（または、入力に `true` の値が含まれなければ）、`missing` を返します。これは [three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic) に従います。

# Examples

```jldoctest
julia> any(i->(4<=i<=6), [3,5,7])
true

julia> any(i -> (println(i); i > 3), 1:10)
1
2
3
4
true

julia> any(i -> i > 0, [1, missing])
true

julia> any(i -> i > 0, [-1, missing])
missing

julia> any(i -> i > 0, [-1, 0])
false
```
