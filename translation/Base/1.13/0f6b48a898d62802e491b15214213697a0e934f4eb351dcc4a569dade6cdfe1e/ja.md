```julia
any(itr)::Bool
```

ブール値のコレクションに`true`である要素があるかを調べ、`itr`内で最初に`true`の値が見つかった時点で（短絡評価により）`true`を返します。`false`で短絡評価するには、[`all`](@ref)を使用してください。

入力に[`missing`](@ref)の値が含まれる場合、欠損値以外のすべての値が`false`であれば（または同じことですが、入力に`true`の値が含まれなければ）、[three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic)に従って`missing`を返します。

関連項目: [`all`](@ref)、[`count`](@ref)、[`sum`](@ref)、[`|`](@ref)、[`||`](@ref)。

# Examples

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
