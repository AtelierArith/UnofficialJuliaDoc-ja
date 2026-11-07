```julia
ispostfixoperator(s::Union{Symbol,AbstractString})
```

Return `true` if the symbol can be used as a postfix operator, `false` otherwise.

# Examples

```jldoctest
julia> Meta.ispostfixoperator(Symbol("'")), Meta.ispostfixoperator(Symbol("'ᵀ")), Meta.ispostfixoperator(:-)
(true, true, false)
```
