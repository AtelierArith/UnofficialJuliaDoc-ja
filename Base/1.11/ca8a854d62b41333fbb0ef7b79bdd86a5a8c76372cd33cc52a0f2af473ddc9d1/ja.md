```
isfinite(f) -> Bool
```

数が有限であるかどうかをテストします。

# 例

```jldoctest
julia> isfinite(5)
true

julia> isfinite(NaN32)
false
```
