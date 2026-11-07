```julia
isone(x)
```

`x == one(x)`の場合は`true`を返します。`x`が配列の場合、`x`が単位行列かどうかを判定します。

# Examples

```jldoctest
julia> isone(1.0)
true

julia> isone([1 0; 0 2])
false

julia> isone([1 0; 0 true])
true
```
