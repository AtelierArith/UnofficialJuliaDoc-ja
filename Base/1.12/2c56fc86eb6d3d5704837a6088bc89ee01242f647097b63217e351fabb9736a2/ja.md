```julia
all(itr) -> Bool
```

ブールコレクションのすべての要素が `true` であるかどうかをテストし、`itr` で最初の `false` 値が見つかるとすぐに `false` を返します（ショートサーキット）。`true` でショートサーキットするには、[`any`](@ref) を使用してください。

入力に [`missing`](@ref) 値が含まれている場合、すべての非欠損値が `true` である場合（または同等に、入力に `false` 値が含まれていない場合）には `missing` を返します。これは [三値論理](https://en.wikipedia.org/wiki/Three-valued_logic) に従います。

関連項目: [`all!`](@ref), [`any`](@ref), [`count`](@ref), [`&`](@ref), [`&&`](@ref), [`allunique`](@ref).

# 例

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
