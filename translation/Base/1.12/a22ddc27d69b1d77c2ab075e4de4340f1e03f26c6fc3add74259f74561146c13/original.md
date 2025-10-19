```julia
binomial(x::Number, k::Integer)
```

The generalized binomial coefficient, defined for `k ≥ 0` by the polynomial

$$
\frac{1}{k!} \prod_{j=0}^{k-1} (x - j)
$$

When `k < 0` it returns zero.

For the case of integer `x`, this is equivalent to the ordinary integer binomial coefficient

$$
\binom{n}{k} = \frac{n!}{k! (n-k)!}
$$

Further generalizations to non-integer `k` are mathematically possible, but involve the Gamma function and/or the beta function, which are not provided by the Julia standard library but are available in external packages such as [SpecialFunctions.jl](https://github.com/JuliaMath/SpecialFunctions.jl).

# External links

  * [Binomial coefficient](https://en.wikipedia.org/wiki/Binomial_coefficient) on Wikipedia.
