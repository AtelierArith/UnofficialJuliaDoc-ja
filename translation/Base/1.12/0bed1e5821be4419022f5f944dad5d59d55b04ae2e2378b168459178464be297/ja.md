```julia
binomial(n::Integer, k::Integer)
```

*二項係数* $\binom{n}{k}$ は、$(1+x)^n$ の多項式展開における $k$ 番目の項の係数です。

$$
n
$$

が非負の場合、これは $n$ 個のアイテムから `k` 個を選ぶ方法の数です：

$$
\binom{n}{k} = \frac{n!}{k! (n-k)!}
$$

ここで $n!$ は [`factorial`](@ref) 関数です。

$$
n
$$

が負の場合、これは次の恒等式に基づいて定義されます：

$$
\binom{n}{k} = (-1)^k \binom{k-n-1}{k}
$$

また [`factorial`](@ref) も参照してください。

# 例

```jldoctest
julia> binomial(5, 3)
10

julia> factorial(5) ÷ (factorial(5-3) * factorial(3))
10

julia> binomial(-5, 3)
-35
```

# 外部リンク

  * [二項係数](https://en.wikipedia.org/wiki/Binomial_coefficient) の Wikipedia。
