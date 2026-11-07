```julia
Unicode.isassigned(c)::Bool
```

指定された文字または整数が割り当て済みの Unicode コードポイントである場合は、`true` を返します。

# Examples

```jldoctest
julia> Unicode.isassigned(101)
true

julia> Unicode.isassigned('\x01')
true
```
