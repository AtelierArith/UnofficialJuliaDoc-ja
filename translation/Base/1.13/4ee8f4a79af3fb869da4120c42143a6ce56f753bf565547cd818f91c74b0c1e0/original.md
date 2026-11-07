```julia
hi, lo = canonicalize2(big, little)
```

Generate a representation where all the nonzero bits in `hi` are more significant than any of the nonzero bits in `lo`. `big` must be larger in absolute value than `little`.
