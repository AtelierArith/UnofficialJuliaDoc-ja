```julia
combine_axes(As...) -> Tuple
```

`As`内のすべての値に対してブロードキャストを行うための結果の軸を決定します。

```jldoctest
julia> Broadcast.combine_axes([1], [1 2; 3 4; 5 6])
(Base.OneTo(3), Base.OneTo(2))

julia> Broadcast.combine_axes(1, 1, 1)
()
```
