```julia
MappingRF(f, rf) -> rf′
```

Create a mapping reducing function `rf′(acc, x) = rf(acc, f(x))`.
