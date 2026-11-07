```julia
broadcast_shape(As...)::Tuple
```

`As` 内のすべての軸（サイズのタプル）にわたるブロードキャストの結果の軸を決定します。

```jldoctest
julia> Broadcast.broadcast_shape((1,2), (2,1))
(2, 2)

julia> Broadcast.broadcast_shape((1,), (1,5), (4,5,3))
(4, 5, 3)
```
