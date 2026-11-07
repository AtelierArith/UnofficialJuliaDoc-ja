```julia
copysign(x, y) -> z
```

`z`を返します。大きさは`x`と同じで、符号は`y`と同じです。

# Examples

```jldoctest
julia> copysign(1, -2)
-1

julia> copysign(-1, 2)
1
```
