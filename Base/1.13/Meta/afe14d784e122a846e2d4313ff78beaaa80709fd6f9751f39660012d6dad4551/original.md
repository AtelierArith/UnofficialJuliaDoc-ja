```julia
isoperator(s::Symbol)
```

Return `true` if the symbol can be used as an operator, `false` otherwise.

# Examples

```jldoctest
julia> Meta.isoperator(:+), Meta.isoperator(:f)
(true, false)
```
