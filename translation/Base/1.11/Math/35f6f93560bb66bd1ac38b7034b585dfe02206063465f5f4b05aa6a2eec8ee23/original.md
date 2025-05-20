```
evalpoly(x, p)
```

Evaluate the polynomial $\sum_k x^{k-1} p[k]$ for the coefficients `p[1]`, `p[2]`, ...; that is, the coefficients are given in ascending order by power of `x`. Loops are unrolled at compile time if the number of coefficients is statically known, i.e. when `p` is a `Tuple`. This function generates efficient code using Horner's method if `x` is real, or using a Goertzel-like [^DK62] algorithm if `x` is complex.

[^DK62]: Donald Knuth, Art of Computer Programming, Volume 2: Seminumerical Algorithms, Sec. 4.6.4.

!!! compat "Julia 1.4"
    This function requires Julia 1.4 or later.


# Examples

```jldoctest
julia> evalpoly(2, (1, 2, 3))
17
```
