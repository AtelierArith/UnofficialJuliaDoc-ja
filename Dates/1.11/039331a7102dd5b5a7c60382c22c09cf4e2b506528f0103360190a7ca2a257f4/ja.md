```julia
isleapyear(dt::TimeType)::Bool
```

`true`を返します。`dt`の年がうるう年の場合です。

# Examples

```jldoctest
julia> isleapyear(Date("2004"))
true

julia> isleapyear(Date("2005"))
false
```
