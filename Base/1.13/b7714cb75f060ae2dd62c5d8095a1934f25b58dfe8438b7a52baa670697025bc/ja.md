```julia
copysign(x, y) -> z
```

`z`を返します。これは、`x`と同じ大きさで、`y`と同じ符号を持ちます。

# Examples

```jldoctest
julia> copysign(1, -2)
-1

julia> copysign(-1, 2)
1
```
