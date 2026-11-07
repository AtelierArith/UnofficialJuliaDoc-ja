```julia
binomial(n::Integer, k::Integer)
```

*二項係数* ``\binom{n}{k}`` は、多項式展開 ``(1+x)^n`` における ``k`` 番目の項の係数です。

``n`` が非負の場合、これは `n` 個の項目から `k` 個を選ぶ方法の数を表します。

```math
\binom{n}{k} = \frac{n!}{k! (n-k)!}
```

ここで、``n!`` は [`factorial`](@ref) 関数です。

``n`` が負の場合は、次の恒等式によって定義されます。

```math
\binom{n}{k} = (-1)^k \binom{k-n-1}{k}
```

[`factorial`](@ref) も参照してください。

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

  * Wikipedia の [Binomial coefficient](https://en.wikipedia.org/wiki/Binomial_coefficient)。
