```julia
binomial(x::Number, k::Integer)
```

一般化二項係数は、`k ≥ 0`に対して、次の多項式で定義されます。

```math
\frac{1}{k!} \prod_{j=0}^{k-1} (x - j)
```

`k < 0`の場合、値はゼロになります。

整数の`x`の場合、これは通常の整数二項係数と等価です。

```math
\binom{n}{k} = \frac{n!}{k! (n-k)!}
```

非整数の`k`へのさらなる一般化も数学的には可能ですが、ガンマ関数やベータ関数が必要になります。これらはJuliaの標準ライブラリには含まれていませんが、[SpecialFunctions.jl](https://github.com/JuliaMath/SpecialFunctions.jl)などの外部パッケージで利用できます。

# External links

  * [Binomial coefficient](https://en.wikipedia.org/wiki/Binomial_coefficient)（Wikipedia）。
