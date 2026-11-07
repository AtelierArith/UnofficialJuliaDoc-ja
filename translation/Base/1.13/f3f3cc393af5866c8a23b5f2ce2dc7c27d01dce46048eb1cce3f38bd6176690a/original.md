```julia
FilteringRF(f, rf) -> rf′
```

Create a filtering reducing function `rf′(acc, x) = f(x) ? rf(acc, x) : acc`.
