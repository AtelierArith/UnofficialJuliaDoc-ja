```julia
ispostfixoperator(s::Union{Symbol,AbstractString})
```

その記号を後置演算子として使用できる場合は`true`を、そうでない場合は`false`を返します。

# Examples

```jldoctest
julia> Meta.ispostfixoperator(Symbol("'")), Meta.ispostfixoperator(Symbol("'ᵀ")), Meta.ispostfixoperator(:-)
(true, true, false)
```
