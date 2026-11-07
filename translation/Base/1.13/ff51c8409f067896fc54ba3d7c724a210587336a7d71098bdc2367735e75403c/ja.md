```julia
all(itr)::Bool
```

ブール値のコレクションのすべての要素が`true`であるかをテストします。`itr`内で最初の`false`値が見つかると、直ちに`false`を返します（短絡評価）。`true`で短絡評価するには、[`any`](@ref)を使用してください。

入力に[`missing`](@ref)値が含まれる場合、[three-valued logic](https://en.wikipedia.org/wiki/Three-valued_logic)に従い、欠損値以外のすべての値が`true`であれば（つまり、入力に`false`値が含まれなければ）、`missing`を返します。

関連項目: [`all!`](@ref)、[`any`](@ref)、[`count`](@ref)、[`&`](@ref)、[`&&`](@ref)、[`allunique`](@ref)。

# Examples

```jldoctest
julia> a = [true,false,false,true]
4-element Vector{Bool}:
 1
 0
 0
 1

julia> all(a)
false

julia> all((println(i); v) for (i, v) in enumerate(a))
1
2
false

julia> all([missing, false])
false

julia> all([true, missing])
missing
```
