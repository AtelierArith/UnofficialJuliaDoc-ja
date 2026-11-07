```julia
promote_shape(s1, s2)
```

末尾の次元が 1 である場合はそれを許容して、2 つの配列の形状に互換性があるか確認し、次元数の多い方の形状を返します。

# Examples

```jldoctest
julia> a = fill(1, (3,4,1,1,1));

julia> b = fill(1, (3,4));

julia> promote_shape(a,b)
(Base.OneTo(3), Base.OneTo(4), Base.OneTo(1), Base.OneTo(1), Base.OneTo(1))

julia> promote_shape((2,3,1,4), (2, 3, 1, 4, 1))
(2, 3, 1, 4, 1)
```
