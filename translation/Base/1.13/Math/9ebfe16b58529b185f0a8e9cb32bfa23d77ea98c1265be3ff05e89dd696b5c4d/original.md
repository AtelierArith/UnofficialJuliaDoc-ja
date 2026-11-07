```julia
Base.Math.scaleinv(x)
```

Compute `(scale, invscale)` where `scale` and `invscale` are non-subnormal (https://en.wikipedia.org/wiki/Subnormal_number) finite powers of two such that `scale * invscale == 1` and `scale` is roughly on the order of `abs(x)`. Inf, NaN, and zero inputs also result in finite nonzero outputs. These values are useful to scale computations to prevent overflow and underflow without round-off errors or division.

UNSTABLE DETAIL: For `x isa IEEEFLoat`, `scale` is chosen to be the `prevpow(2,abs(x))` when possible, but is never less than floatmin(x) or greater than inv(floatmin(x)). `Inf` and `NaN` resolve to `inv(floatmin(x))`. This behavior is subject to change.

# Examples

```jldoctest
julia> Base.Math.scaleinv(7.5)
(4.0, 0.25)
```
