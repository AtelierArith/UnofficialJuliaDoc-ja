```
isbinaryoperator(s::Symbol)
```

Return `true` if the symbol can be used as a binary (infix) operator, `false` otherwise.

# Examples

```jldoctest
julia> Meta.isbinaryoperator(:-), Meta.isbinaryoperator(:√), Meta.isbinaryoperator(:f)
(true, false, false)
```
