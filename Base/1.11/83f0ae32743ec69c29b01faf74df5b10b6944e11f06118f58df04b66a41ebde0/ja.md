```
isbinaryoperator(s::Symbol)
```

シンボルが二項（中置）演算子として使用できる場合は `true` を返し、それ以外の場合は `false` を返します。

# 例

```jldoctest
julia> Meta.isbinaryoperator(:-), Meta.isbinaryoperator(:√), Meta.isbinaryoperator(:f)
(true, false, false)
```
