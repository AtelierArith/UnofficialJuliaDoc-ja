```
binomial(n::Integer, k::Integer)
```

The *binomial coefficient* $\binom{n}{k}$, being the coefficient of the $k$th term in the polynomial expansion of $(1+x)^n$.

If $n$ is non-negative, then it is the number of ways to choose `k` out of `n` items:

$$
\binom{n}{k} = \frac{n!}{k! (n-k)!}
$$

where $n!$ is the [`factorial`](@ref) function.

If $n$ is negative, then it is defined in terms of the identity

$$
\binom{n}{k} = (-1)^k \binom{k-n-1}{k}
$$

See also [`factorial`](@ref).

# Examples

```jldoctest
julia> binomial(5, 3)
10

julia> factorial(5) ÷ (factorial(5-3) * factorial(3))
10

julia> binomial(-5, 3)
-35
```

# External links

  * [Binomial coefficient](https://en.wikipedia.org/wiki/Binomial_coefficient) on Wikipedia.
