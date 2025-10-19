```julia
result_style(s1::BroadcastStyle[, s2::BroadcastStyle]) -> BroadcastStyle
```

Takes one or two `BroadcastStyle`s and combines them using [`BroadcastStyle`](@ref) to determine a common `BroadcastStyle`.

# Examples

```jldoctest
julia> Broadcast.result_style(Broadcast.DefaultArrayStyle{0}(), Broadcast.DefaultArrayStyle{3}())
Base.Broadcast.DefaultArrayStyle{3}()

julia> Broadcast.result_style(Broadcast.Unknown(), Broadcast.DefaultArrayStyle{1}())
Base.Broadcast.DefaultArrayStyle{1}()
```
