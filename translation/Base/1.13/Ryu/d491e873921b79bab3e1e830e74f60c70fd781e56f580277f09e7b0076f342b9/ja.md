```julia
b, e10 = reduce_shortest(f[, maxsignif])
```

`abs(f) == b * 10^e10` と `b` が整数となる最短の10進表現に変換します。`maxsignif` 引数が指定されている場合は、`b < maxsignif`。
