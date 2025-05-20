```
<=(x, y)
≤(x,y)
```

小なりイコール比較演算子。`(x < y) | (x == y)` にフォールバックします。

# 例

```jldoctest
julia> 'a' <= 'b'
true

julia> 7 ≤ 7 ≤ 9
true

julia> "abc" ≤ "abc"
true

julia> 5 <= 3
false
```
