```julia
maxintfloat(T, S)
```

指定された浮動小数点型 `T` で表現でき、かつ整数型 `S` で表現できる最大の整数を超えない、連続する整数のうち最大のものです。言い換えると、`maxintfloat(T)` と [`typemax(S)`](@ref) の小さい方です。
