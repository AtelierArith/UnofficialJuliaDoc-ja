```julia
maxintfloat(T, S)
```

指定された浮動小数点型 `T` で表現でき、かつ整数型 `S` で表現可能な最大の整数を超えない、連続する整数のうち最大のもの。言い換えると、`maxintfloat(T)` と [`typemax(S)`](@ref) の最小値です。
