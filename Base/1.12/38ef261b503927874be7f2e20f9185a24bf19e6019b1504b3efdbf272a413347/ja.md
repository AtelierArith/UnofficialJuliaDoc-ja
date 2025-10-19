```julia
precision(num::AbstractFloat; base::Integer=2)
precision(T::Type; base::Integer=2)
```

浮動小数点数の精度を取得します。これは、有効桁数におけるビット数によって定義されます。また、浮動小数点型 `T` の精度も取得できます（`T` が [`BigFloat`](@ref) のような可変精度型である場合は、その現在のデフォルト）。

`base` が指定されている場合、その基数における有効桁数の最大値を返します。

!!! compat "Julia 1.8"
    `base` キーワードは、少なくとも Julia 1.8 が必要です。

