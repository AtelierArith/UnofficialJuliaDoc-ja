```julia
isoperator(s::Symbol)
```

その記号を演算子として使用できる場合は `true` を返し、使用できない場合は `false` を返してください。

# Examples

```jldoctest
julia> Meta.isoperator(:+), Meta.isoperator(:f)
(true, false)
```
