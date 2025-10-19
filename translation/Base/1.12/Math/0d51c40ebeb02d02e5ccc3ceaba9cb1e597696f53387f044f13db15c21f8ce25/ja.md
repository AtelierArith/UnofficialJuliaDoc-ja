```julia
cotd(x::T) where {T <: Number} -> float(T)
```

`x`が度数であるとき、`x`のコタンジェントを計算します。

`isinf(x)`の場合は[`DomainError`](@ref)を投げ、`isnan(x)`の場合は`T(NaN)`を返します。
