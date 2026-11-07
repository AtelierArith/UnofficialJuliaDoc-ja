```julia
sincosd(x::T) where T -> Tuple{float(T),float(T)}
```

`x` の正弦と余弦を同時に計算し、`x` が度数法で表される場合は、タプル `(sine, cosine)` を返します。

`isinf(x)` の場合は [`DomainError`](@ref) をスローし、`isnan(x)` の場合は `(T(NaN), T(NaN))` タプルを返します。

!!! compat "Julia 1.3"
    この関数を使用するには、Julia 1.3 以降が必要です。

