```
>=(x, y)
≥(x,y)
```

Greater-than-or-equals comparison operator. Falls back to `y <= x`.

# Examples

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
