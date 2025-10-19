```julia
big(T::Type)
```

任意の精度を持つ数値型 `T` を表す型を計算します。`typeof(big(zero(T)))` と同等です。

# 例

```jldoctest
julia> big(Rational)
Rational{BigInt}

julia> big(Float64)
BigFloat

julia> big(Complex{Int})
Complex{BigInt}
```
