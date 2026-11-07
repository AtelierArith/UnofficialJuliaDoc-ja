```julia
insert!(a::Vector, index::Integer, item)
```

指定された`index`の位置に、`item`を`a`に挿入します。`index`は、挿入後の`a`における`item`のインデックスです。

関連項目: [`push!`](@ref)、[`replace`](@ref)、[`popat!`](@ref)、[`splice!`](@ref)。

# Examples

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
