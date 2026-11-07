```julia
<=(x, y)
≤(x,y)
```

以下以下比較演算子。`(x < y) | (x == y)`にフォールバックします。

# Examples

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
