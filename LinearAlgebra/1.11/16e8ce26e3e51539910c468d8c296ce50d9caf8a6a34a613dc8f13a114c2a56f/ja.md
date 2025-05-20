```
axpby!(α, x::AbstractArray, β, y::AbstractArray)
```

`y`を`x * α + y * β`で上書きし、`y`を返します。`x`と`y`が同じ軸を持つ場合、これは`y .= x .* a .+ y .* β`と同等です。

# 例

```jldoctest
julia> x = [1; 2; 3];

julia> y = [4; 5; 6];

julia> axpby!(2, x, 2, y)
3-element Vector{Int64}:
 10
 14
 18
```
