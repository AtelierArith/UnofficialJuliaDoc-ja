```julia
ExponentialBackOff(; n=1, first_delay=0.05, max_delay=10.0, factor=5.0, jitter=0.1)
```

要素が `factor` * (1 ± `jitter`) の範囲の割合で指数的に増加する、長さ `n` の [`Float64`](@ref) イテレータ。最初の要素は `first_delay` で、すべての要素は `max_delay` に制限されます。
