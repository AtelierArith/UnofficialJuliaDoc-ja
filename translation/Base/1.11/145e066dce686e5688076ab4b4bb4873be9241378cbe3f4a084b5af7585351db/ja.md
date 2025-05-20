```
isoperator(s::Symbol)
```

シンボルが演算子として使用できる場合は `true` を返し、それ以外の場合は `false` を返します。

# 例

```jldoctest
julia> Meta.isoperator(:+), Meta.isoperator(:f)
(true, false)
```
