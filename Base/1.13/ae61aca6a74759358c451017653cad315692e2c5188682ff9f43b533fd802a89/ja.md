```julia
maxintfloat(T=Float64)
```

指定された浮動小数点型 `T`（デフォルトは `Float64`）で正確に表現できる、連続する整数値の浮動小数点数のうち最大のもの。

つまり、`maxintfloat` は、`n+1` が型 `T` で正確に表現できないような、最小の正の整数値の浮動小数点数 `n` を返します。

`Integer` 型の値が必要な場合は、`Integer(maxintfloat(T))` を使用してください。

関連項目: [`typemax`](@ref)、[`floatmax`](@ref)。
