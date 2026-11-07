```julia
any(p, itr)::Bool
```

`itr` の要素のいずれかについて、述語 `p` が `true` を返すかどうかを判定します。`itr` の中で `p` が `true` を返す最初の要素が見つかった時点で、`true` を返します（短絡評価）。`false` で短絡評価するには、[`all`](@ref) を使用してください。

入力に [`missing`](@ref) の値が含まれる場合、欠損値以外のすべての値が `false` であれば（つまり、入力に `true` の値が含まれない場合）、`missing` を返します。これは [three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic) に従います。

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
