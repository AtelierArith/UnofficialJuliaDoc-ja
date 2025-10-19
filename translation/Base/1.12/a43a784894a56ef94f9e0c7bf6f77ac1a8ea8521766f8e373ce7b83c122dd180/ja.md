```julia
insert!(a::Vector, index::Integer, item)
```

`item`を指定された`index`で`a`に挿入します。`index`は結果の`a`における`item`のインデックスです。

参照: [`push!`](@ref), [`replace`](@ref), [`popat!`](@ref), [`splice!`](@ref).

# 例

```jldoctest
julia> insert!(Any[1:6;], 3, "here")
7-element Vector{Any}:
 1
 2
  "here"
 3
 4
 5
 6
```
