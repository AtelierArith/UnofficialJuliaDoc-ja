```
<=(x, y)
≤(x,y)
```

Less-than-or-equals comparison operator. Falls back to `(x < y) | (x == y)`.

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
