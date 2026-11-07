```julia
hoveridx(state::SelectorState) -> Int
```

Compute the signed index into `candidates` or `gathered` for hover.

Positive values index `candidates`, negative values index `gathered`, zero is invalid.
