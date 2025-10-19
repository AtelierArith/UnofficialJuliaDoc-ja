```julia
any(p, itr) -> Bool
```

述語 `p` が `itr` の任意の要素に対して `true` を返すかどうかを判断し、`p` が `true` を返す `itr` の最初のアイテムに出会った時点で `true` を返します（ショートサーキット）。`false` に対してショートサーキットを行うには、[`all`](@ref) を使用してください。

入力に [`missing`](@ref) 値が含まれている場合、すべての非欠損値が `false` である場合（または同等に、入力に `true` 値が含まれていない場合）には `missing` を返し、[三値論理](https://en.wikipedia.org/wiki/Three-valued_logic)に従います。

# 例

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
