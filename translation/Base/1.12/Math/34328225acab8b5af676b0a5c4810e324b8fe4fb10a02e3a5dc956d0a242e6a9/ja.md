```julia
sincosd(x::T) where T -> Tuple{float(T),float(T)}
```

同時に `x` のサインとコサインを計算します。ここで `x` は度数法であり、タプル `(sine, cosine)` を返します。

`isinf(x)` の場合は [`DomainError`](@ref) をスローし、`isnan(x)` の場合は `(T(NaN), T(NaN))` のタプルを返します。

!!! compat "Julia 1.3"
    この関数は少なくとも Julia 1.3 を必要とします。

