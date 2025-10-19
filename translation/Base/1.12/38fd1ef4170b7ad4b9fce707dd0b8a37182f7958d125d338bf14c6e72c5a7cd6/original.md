```julia
Base.add_sum(x, y)
```

The reduction operator used in `sum`. The main difference from [`+`](@ref) is that small integers are promoted to `Int`/`UInt`.
