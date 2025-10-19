```julia
all(p, itr) -> Bool
```

述語 `p` が `itr` のすべての要素に対して `true` を返すかどうかを判断し、`p` が `false` を返す最初のアイテムが `itr` で見つかった時点で `false` を返します（ショートサーキット）。`true` でショートサーキットするには、[`any`](@ref) を使用してください。

入力に [`missing`](@ref) 値が含まれている場合、すべての非欠損値が `true` である場合（または同等に、入力に `false` 値が含まれていない場合）には `missing` を返します。これは [三値論理](https://en.wikipedia.org/wiki/Three-valued_logic) に従います。

# 例

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
