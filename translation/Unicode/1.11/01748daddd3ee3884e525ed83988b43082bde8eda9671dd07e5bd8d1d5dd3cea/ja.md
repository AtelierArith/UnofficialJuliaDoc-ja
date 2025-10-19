```julia
Unicode.isassigned(c) -> Bool
```

与えられた文字または整数が割り当てられたUnicodeコードポイントである場合は`true`を返します。

# 例

```jldoctest
julia> Unicode.isassigned(101)
true

julia> Unicode.isassigned('\x01')
true
```
