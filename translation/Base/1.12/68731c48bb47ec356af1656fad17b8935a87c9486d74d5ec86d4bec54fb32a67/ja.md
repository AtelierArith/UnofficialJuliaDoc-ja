```julia
indexin(a, b)
```

`b`のメンバーである`a`の各値に対する最初のインデックスを含む配列を返します。出力配列は、`a`が`b`のメンバーでない場合は`nothing`を含みます。

関連情報: [`sortperm`](@ref), [`findfirst`](@ref).

# 例

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
