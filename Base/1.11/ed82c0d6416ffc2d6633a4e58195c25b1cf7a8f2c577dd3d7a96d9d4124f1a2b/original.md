```
flipsign(x, y)
```

Return `x` with its sign flipped if `y` is negative. For example `abs(x) = flipsign(x,x)`.

# Examples

```jldoctest
julia> flipsign(5, 3)
5

julia> flipsign(5, -3)
-5
```
