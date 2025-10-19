```julia
isunaryoperator(s::Symbol)
```

シンボルが単項（接頭辞）演算子として使用できる場合は `true` を返し、それ以外の場合は `false` を返します。

# 例

```jldoctest
julia> Meta.isunaryoperator(:-), Meta.isunaryoperator(:√), Meta.isunaryoperator(:f)
(true, true, false)
```
