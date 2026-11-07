```julia
rem2pi(x, r::RoundingMode)
```

`x`を`2π`で整数除算したときの余りを、商の丸めモード`r`に従って計算します。つまり、次の量を

```julia
x - 2π*round(x/(2π),r)
```

中間で丸めることなく計算します。この処理では内部的に高精度の2π近似値を使用するため、`rem(x,2π,r)`よりも正確な結果が得られます。

  * `r == RoundNearest`の場合、結果は区間``[-π, π]``に含まれます。通常、これが最も正確な結果です。[`RoundNearest`](@ref)も参照してください。
  * `r == RoundToZero`の場合、`x`が正なら結果は区間``[0, 2π]``に、そうでなければ``[-2π, 0]``に含まれます。[`RoundToZero`](@ref)も参照してください。
  * `r == RoundDown`の場合、結果は区間``[0, 2π]``に含まれます。[`RoundDown`](@ref)も参照してください。
  * `r == RoundUp`の場合、結果は区間``[-2π, 0]``に含まれます。[`RoundUp`](@ref)も参照してください。

# Examples

```jldoctest
julia> rem2pi(7pi/4, RoundNearest)
-0.7853981633974485

julia> rem2pi(7pi/4, RoundDown)
5.497787143782138
```
