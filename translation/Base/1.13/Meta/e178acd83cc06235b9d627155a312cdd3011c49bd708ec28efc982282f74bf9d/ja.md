```julia
isbinaryoperator(s::Symbol)
```

その記号を二項（中置）演算子として使用できる場合は、`true`を返します。使用できない場合は、`false`を返します。

# Examples

```jldoctest
julia> Meta.isbinaryoperator(:-), Meta.isbinaryoperator(:√), Meta.isbinaryoperator(:f)
(true, false, false)
```
