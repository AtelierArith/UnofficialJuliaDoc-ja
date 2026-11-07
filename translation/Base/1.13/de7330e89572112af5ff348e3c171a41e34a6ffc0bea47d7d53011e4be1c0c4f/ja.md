```julia
big(T::Type)
```

任意精度の数値型 `T` を表す型を計算します。`typeof(big(zero(T)))` と同等です。

# Examples

```jldoctest
julia> big(Rational)
Rational{BigInt}

julia> big(Float64)
BigFloat

julia> big(Complex{Int})
Complex{BigInt}
```
