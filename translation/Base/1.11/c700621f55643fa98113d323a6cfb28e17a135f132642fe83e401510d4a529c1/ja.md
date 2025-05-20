```
ExponentialBackOff(; n=1, first_delay=0.05, max_delay=10.0, factor=5.0, jitter=0.1)
```

長さ `n` の [`Float64`](@ref) イテレータで、その要素は `factor` * (1 ± `jitter`) の範囲で指数的に増加します。最初の要素は `first_delay` で、すべての要素は `max_delay` に制限されます。
