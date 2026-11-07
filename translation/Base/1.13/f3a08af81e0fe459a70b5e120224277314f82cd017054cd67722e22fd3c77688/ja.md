```julia
all(p, itr)::Bool
```

述語 `p` が `itr` のすべての要素に対して `true` を返すかどうかを判定します。`itr` の項目のうち、`p` が `false` を返す最初の項目が見つかると、ただちに `false` を返します（短絡評価）。`true` で短絡評価するには、[`any`](@ref) を使用してください。

入力に [`missing`](@ref) の値が含まれる場合、`true` である非欠損値がすべて `missing` を返します（または、入力に `false` の値が含まれない場合も同様です）。これは [three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic) に従います。

# Examples

```jldoctest
julia> all(i->(4<=i<=6), [4,5,6])
true

julia> all(i -> (println(i); i < 3), 1:10)
1
2
3
false

julia> all(i -> i > 0, [1, missing])
missing

julia> all(i -> i > 0, [-1, missing])
false

julia> all(i -> i > 0, [1, 2])
true
```
