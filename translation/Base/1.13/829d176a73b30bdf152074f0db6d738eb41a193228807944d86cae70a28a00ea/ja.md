```julia
indexin(a, b)
```

`a`の各値について、`b`の要素である場合に、`b`内で最初に現れるインデックスを含む配列を返します。`a`が`b`の要素でない場合、出力配列の該当箇所には`nothing`が含まれます。

関連項目: [`sortperm`](@ref)、[`findfirst`](@ref)。

# Examples

```jldoctest
julia> a = ['a', 'b', 'c', 'b', 'd', 'a'];

julia> b = ['a', 'b', 'c'];

julia> indexin(a, b)
6-element Vector{Union{Nothing, Int64}}:
 1
 2
 3
 2
  nothing
 1

julia> indexin(b, a)
3-element Vector{Union{Nothing, Int64}}:
 1
 2
 3
```
