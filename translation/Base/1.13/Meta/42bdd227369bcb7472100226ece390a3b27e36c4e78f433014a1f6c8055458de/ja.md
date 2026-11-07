```julia
isunaryoperator(s::Symbol)
```

その記号を単項（前置）演算子として使用できる場合は、`true` を返します。使用できない場合は、`false` を返します。

# Examples

```jldoctest
julia> Meta.isunaryoperator(:-), Meta.isunaryoperator(:√), Meta.isunaryoperator(:f)
(true, true, false)
```
