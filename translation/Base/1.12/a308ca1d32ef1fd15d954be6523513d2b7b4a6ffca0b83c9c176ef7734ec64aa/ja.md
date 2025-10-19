```julia
isperm(v) -> Bool
```

`v` が有効な置換であれば `true` を返します。

# 例

```jldoctest
julia> isperm([1; 2])
true

julia> isperm([1; 3])
false
```
