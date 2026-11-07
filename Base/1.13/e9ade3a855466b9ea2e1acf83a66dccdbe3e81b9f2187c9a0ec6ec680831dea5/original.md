```julia
Base.mul_prod(x, y)
```

The reduction operator used in `prod`. The main difference from [`*`](@ref) is that small integers are promoted to `Int`/`UInt`.
