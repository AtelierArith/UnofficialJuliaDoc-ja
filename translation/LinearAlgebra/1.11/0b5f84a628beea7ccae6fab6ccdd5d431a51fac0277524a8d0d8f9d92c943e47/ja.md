```
axpy!(α, x::AbstractArray, y::AbstractArray)
```

`y`を`x * α + y`で上書きし、`y`を返します。`x`と`y`が同じ軸を持つ場合、これは`y .+= x .* a`と同等です。

# 例

```jldoctest
julia> x = [1; 2; 3];

julia> y = [4; 5; 6];

julia> axpy!(2, x, y)
3-element Vector{Int64}:
  6
  9
 12
```
