```julia
RoundingMode
```

浮動小数点演算の丸めモードを制御する型です（[`rounding`](@ref)/[`setrounding`](@ref)関数で使用）。また、最も近い整数への丸めを行う関数（[`round`](@ref)関数）の省略可能な引数としても使用します。

現在サポートされている丸めモードは次のとおりです。

  * [`RoundNearest`](@ref)（デフォルト）
  * [`RoundNearestTiesAway`](@ref)
  * [`RoundNearestTiesUp`](@ref)
  * [`RoundToZero`](@ref)
  * [`RoundFromZero`](@ref)
  * [`RoundUp`](@ref)
  * [`RoundDown`](@ref)

!!! compat "Julia 1.9"
    `RoundFromZero`を使用するには、Julia 1.9以降が必要です。それ以前のバージョンでは、`BigFloat`に対してのみ`RoundFromZero`がサポートされています。

