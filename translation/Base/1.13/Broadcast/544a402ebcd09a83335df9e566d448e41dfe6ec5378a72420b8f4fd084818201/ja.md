```julia
result_style(s1::BroadcastStyle[, s2::BroadcastStyle])::BroadcastStyle
```

1つまたは2つの`BroadcastStyle`を受け取り、[`BroadcastStyle`](@ref)を使ってそれらを組み合わせ、共通の`BroadcastStyle`を求めます。

# Examples

```jldoctest
julia> Broadcast.result_style(Broadcast.DefaultArrayStyle{0}(), Broadcast.DefaultArrayStyle{3}())
Base.Broadcast.DefaultArrayStyle{3}()

julia> Broadcast.result_style(Broadcast.Unknown(), Broadcast.DefaultArrayStyle{1}())
Base.Broadcast.DefaultArrayStyle{1}()
```
