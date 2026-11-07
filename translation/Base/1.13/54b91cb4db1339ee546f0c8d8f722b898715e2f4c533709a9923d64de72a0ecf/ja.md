```julia
<=(x, y)
≤(x,y)
```

以下の演算子にフォールバックする、小なりイコール比較演算子です。`(x < y) | (x == y)`

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
