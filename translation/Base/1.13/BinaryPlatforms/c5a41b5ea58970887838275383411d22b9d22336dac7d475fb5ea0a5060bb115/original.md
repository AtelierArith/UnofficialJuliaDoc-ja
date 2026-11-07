```julia
compare_default(a::String, b::String, a_requested::Bool, b_requested::Bool)
```

Default comparison strategy that falls back to `a == b`.  This only ever happens if both `a` and `b` request this strategy, as any other strategy is preferable to this one.
