```julia
binomial(x::Number, k::Integer)
```

一般化された二項係数は、`k ≥ 0` の場合に次の多項式によって定義されます。

$$
\frac{1}{k!} \prod_{j=0}^{k-1} (x - j)
$$

`k < 0` の場合はゼロを返します。

整数 `x` の場合、これは通常の整数二項係数に相当します。

$$
\binom{n}{k} = \frac{n!}{k! (n-k)!}
$$

非整数 `k` へのさらなる一般化は数学的に可能ですが、ガンマ関数および/またはベータ関数を含むため、Julia標準ライブラリには含まれておらず、[SpecialFunctions.jl](https://github.com/JuliaMath/SpecialFunctions.jl) のような外部パッケージで利用可能です。

# 外部リンク

  * [二項係数](https://en.wikipedia.org/wiki/Binomial_coefficient) - Wikipedia.
