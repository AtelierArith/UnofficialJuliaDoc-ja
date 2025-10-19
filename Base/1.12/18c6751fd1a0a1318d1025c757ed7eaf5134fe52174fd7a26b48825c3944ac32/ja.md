```julia
promote_shape(s1, s2)
```

2つの配列の形状が互換性があるかを確認し、末尾の単一次元を許可し、より多くの次元を持つ形状を返します。

# 例

```jldoctest
julia> a = fill(1, (3,4,1,1,1));

julia> b = fill(1, (3,4));

julia> promote_shape(a,b)
(Base.OneTo(3), Base.OneTo(4), Base.OneTo(1), Base.OneTo(1), Base.OneTo(1))

julia> promote_shape((2,3,1,4), (2, 3, 1, 4, 1))
(2, 3, 1, 4, 1)
```
