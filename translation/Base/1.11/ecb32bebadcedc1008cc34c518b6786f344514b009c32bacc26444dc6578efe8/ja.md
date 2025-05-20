```
cmp(x,y)
```

`x`が`y`より小さい場合は-1、等しい場合は0、大きい場合は1を返します。`isless`によって実装された全順序を使用します。

# 例

```jldoctest
julia> cmp(1, 2)
-1

julia> cmp(2, 1)
1

julia> cmp(2+im, 3-im)
ERROR: MethodError: no method matching isless(::Complex{Int64}, ::Complex{Int64})
[...]
```
