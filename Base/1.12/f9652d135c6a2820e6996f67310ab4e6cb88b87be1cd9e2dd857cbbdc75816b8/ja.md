```julia
maxintfloat(T, S)
```

与えられた浮動小数点型 `T` で表現可能な最大の連続整数であり、かつ整数型 `S` によって表現可能な最大整数を超えない。言い換えれば、これは `maxintfloat(T)` と [`typemax(S)`](@ref) の最小値である。
