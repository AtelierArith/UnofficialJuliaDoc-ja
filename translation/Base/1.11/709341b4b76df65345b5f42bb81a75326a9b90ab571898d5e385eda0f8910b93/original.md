```
Fix1(f, x)
```

A type representing a partially-applied version of the two-argument function `f`, with the first argument fixed to the value "x". In other words, `Fix1(f, x)` behaves similarly to `y->f(x, y)`.

See also [`Fix2`](@ref Base.Fix2).
