```julia
Broadcast.instantiate(bc::Broadcasted)
```

Construct and check the axes for the lazy Broadcasted object `bc`.

Custom [`BroadcastStyle`](@ref)s may override this default in cases where it is fast and easy to compute and verify the resulting `axes` on-demand, leaving the `axis` field of the `Broadcasted` object empty (populated with [`nothing`](@ref)).
