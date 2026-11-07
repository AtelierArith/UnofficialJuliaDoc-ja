```julia
cmp(x,y)
```

`x` が `y` より小さい場合は -1、等しい場合は 0、大きい場合は 1 を返します。`isless` が実装する全順序を使用します。

# Examples

```jldoctest
julia> cmp(1, 2)
-1

julia> cmp(2, 1)
1

julia> cmp(2+im, 3-im)
ERROR: MethodError: no method matching isless(::Complex{Int64}, ::Complex{Int64})
[...]
```
