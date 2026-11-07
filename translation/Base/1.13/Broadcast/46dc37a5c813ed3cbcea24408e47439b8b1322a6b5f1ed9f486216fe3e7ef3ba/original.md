```julia
broadcast_shape(As...)::Tuple
```

Determine the result axes for broadcasting across all axes (size Tuples) in `As`.

```jldoctest
julia> Broadcast.broadcast_shape((1,2), (2,1))
(2, 2)

julia> Broadcast.broadcast_shape((1,), (1,5), (4,5,3))
(4, 5, 3)
```
