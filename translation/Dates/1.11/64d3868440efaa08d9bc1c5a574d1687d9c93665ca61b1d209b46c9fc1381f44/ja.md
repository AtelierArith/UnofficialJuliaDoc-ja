```
isleapyear(dt::TimeType) -> Bool
```

`dt`の年がうるう年であれば`true`を返します。

# 例

```jldoctest
julia> isleapyear(Date("2004"))
true

julia> isleapyear(Date("2005"))
false
```
