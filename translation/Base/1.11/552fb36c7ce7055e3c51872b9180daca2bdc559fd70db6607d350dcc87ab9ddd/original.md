```
gcdx(a, b)
```

Computes the greatest common (positive) divisor of `a` and `b` and their Bézout coefficients, i.e. the integer coefficients `u` and `v` that satisfy $ua+vb = d = gcd(a, b)$. $gcdx(a, b)$ returns $(d, u, v)$.

The arguments may be integer and rational numbers.

!!! compat "Julia 1.4"
    Rational arguments require Julia 1.4 or later.


# Examples

```jldoctest
julia> gcdx(12, 42)
(6, -3, 1)

julia> gcdx(240, 46)
(2, -9, 47)
```

!!! note
    Bézout coefficients are *not* uniquely defined. `gcdx` returns the minimal Bézout coefficients that are computed by the extended Euclidean algorithm. (Ref: D. Knuth, TAoCP, 2/e, p. 325, Algorithm X.) For signed integers, these coefficients `u` and `v` are minimal in the sense that $|u| < |b/d|$ and $|v| < |a/d|$. Furthermore, the signs of `u` and `v` are chosen so that `d` is positive. For unsigned integers, the coefficients `u` and `v` might be near their `typemax`, and the identity then holds only via the unsigned integers' modulo arithmetic.

