```julia
cosc(x::T) where {T <: Number} -> float(T)
```

$$
x \neq 0
$$

の場合は $\cos(\pi x) / x - \sin(\pi x) / (\pi x^2)$ を計算し、$x = 0$ の場合は $0$ を返します。これは `sinc(x)` の導関数です。

`isnan(x)` の場合は `T(NaN)` を返します。

詳細は [`sinc`](@ref) を参照してください。
