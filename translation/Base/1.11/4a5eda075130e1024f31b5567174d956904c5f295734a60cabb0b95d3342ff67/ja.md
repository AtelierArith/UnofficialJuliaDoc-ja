```
>=(x, y)
≥(x,y)
```

大なりイコール比較演算子。`y <= x` にフォールバックします。

# 例

```jldoctest
julia> 'a' >= 'b'
false

julia> 7 ≥ 7 ≥ 3
true

julia> "abc" ≥ "abc"
true

julia> 5 >= 3
true
```
