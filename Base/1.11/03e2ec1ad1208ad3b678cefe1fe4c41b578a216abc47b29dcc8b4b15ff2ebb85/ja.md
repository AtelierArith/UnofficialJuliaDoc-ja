```
!==(x, y)
≢(x,y)
```

常に [`===`](@ref) の逆の答えを返します。

# 例

```jldoctest
julia> a = [1, 2]; b = [1, 2];

julia> a ≢ b
true

julia> a ≢ a
false
```
