```julia
Ryu.pow5bits(e)
```

Computes `e == 0 ? 1 : ceil(log2(5^e))`. This is valid for `e < 3529` (if performend in `Int32` arithmetic).
