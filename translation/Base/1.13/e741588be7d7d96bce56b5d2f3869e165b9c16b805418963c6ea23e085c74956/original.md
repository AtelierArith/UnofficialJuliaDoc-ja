```julia
FlatteningRF(rf) -> rf′
```

Create a flattening reducing function that is roughly equivalent to `rf′(acc, x) = foldl(rf, x; init=acc)`.
