```
nextfloat(x::AbstractFloat)
```

同じ型の最小の浮動小数点数 `y` を返します。条件は `x < y` です。もしそのような `y` が存在しない場合（例えば `x` が `Inf` または `NaN` の場合）、`x` を返します。

関連情報: [`prevfloat`](@ref), [`eps`](@ref), [`issubnormal`](@ref).
