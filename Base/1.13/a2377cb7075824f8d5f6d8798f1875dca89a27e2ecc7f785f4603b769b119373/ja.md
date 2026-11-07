```julia
precision(num::AbstractFloat; base::Integer=2)
precision(T::Type; base::Integer=2)
```

浮動小数点数の精度（仮数部の有効ビット数で定義）を取得します。または、浮動小数点型 `T` の精度を取得します（`T` が [`BigFloat`](@ref) のような可変精度型の場合は、現在のデフォルト精度）。

`base` を指定すると、その基数での仮数部の桁数に対応する最大値を返します。

!!! compat "Julia 1.8"
    `base` キーワードを使用するには、Julia 1.8 以降が必要です。

