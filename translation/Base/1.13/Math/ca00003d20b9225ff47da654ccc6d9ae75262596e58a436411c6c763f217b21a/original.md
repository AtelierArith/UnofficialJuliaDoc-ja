```julia
fastabs(x::Number)
```

Faster `abs`-like function for rough magnitude comparisons. `fastabs` is equivalent to `abs(x)` for most `x`, but for complex `x` it computes `abs(real(x))+abs(imag(x))` rather than requiring `hypot`.
