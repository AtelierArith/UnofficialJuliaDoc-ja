```
circshift!(a::AbstractVector, shift::Integer)
```

ベクトル `a` のデータを `shift` ポジションだけ円環的にシフトまたは回転します。

# 例

```jldoctest
julia> circshift!([1, 2, 3, 4, 5], 2)
5-element Vector{Int64}:
 4
 5
 1
 2
 3

julia> circshift!([1, 2, 3, 4, 5], -2)
5-element Vector{Int64}:
 3
 4
 5
 1
 2
```
