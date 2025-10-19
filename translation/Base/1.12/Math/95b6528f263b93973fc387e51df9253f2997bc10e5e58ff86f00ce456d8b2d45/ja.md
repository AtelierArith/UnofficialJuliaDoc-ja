```julia
sincos(x::T) where T -> Tuple{float(T),float(T)}
```

`x`がラジアンであるとき、`x`のサインとコサインを同時に計算し、タプル`(sine, cosine)`を返します。

`isinf(x)`の場合は[`DomainError`](@ref)をスローし、`isnan(x)`の場合は`(T(NaN), T(NaN))`を返します。

他に[`cis`](@ref)、[`sincospi`](@ref)、[`sincosd`](@ref)も参照してください。
