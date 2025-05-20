```
any(itr) -> Bool
```

ブールコレクションの任意の要素が `true` であるかをテストし、`itr` 内で最初の `true` 値が見つかった時点で `true` を返します（ショートサーキット）。`false` でショートサーキットするには、[`all`](@ref) を使用してください。

入力に [`missing`](@ref) 値が含まれている場合、すべての非欠損値が `false` である場合（または同等に、入力に `true` 値が含まれていない場合）には `missing` を返し、[三値論理](https://en.wikipedia.org/wiki/Three-valued_logic)に従います。

関連項目: [`all`](@ref), [`count`](@ref), [`sum`](@ref), [`|`](@ref), , [`||`](@ref).

# 例

```jldoctest
julia> a = [true,false,false,true]
4-element Vector{Bool}:
 1
 0
 0
 1

julia> any(a)
true

julia> any((println(i); v) for (i, v) in enumerate(a))
1
true

julia> any([missing, true])
true

julia> any([false, missing])
missing
```
