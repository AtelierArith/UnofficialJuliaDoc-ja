```julia
prevfloat(x::AbstractFloat)
```

`x`と同じ型で、`y < x`を満たす最大の浮動小数点数`y`を返します。そのような`y`が存在しない場合（たとえば、`x`が`-Inf`または`NaN`の場合）、`x`を返します。
