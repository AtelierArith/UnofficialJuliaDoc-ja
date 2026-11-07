```julia
isleapyear(dt::TimeType)::Bool
```

`true` を返します。`dt` がうるう年の場合に限ります。

# Examples

```jldoctest
julia> isleapyear(Date("2004"))
true

julia> isleapyear(Date("2005"))
false
```
