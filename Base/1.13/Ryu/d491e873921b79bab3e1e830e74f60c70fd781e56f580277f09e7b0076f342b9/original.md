```julia
b, e10 = reduce_shortest(f[, maxsignif])
```

Reduce to shortest decimal representation where `abs(f) == b * 10^e10` and `b` is an integer. If a `maxsignif` argument is provided, then `b < maxsignif`.
