```julia
RoundingMode
```

浮動小数点演算の丸めモードを制御するため（[`rounding`](@ref)/[`setrounding`](@ref)関数を介して）、または最も近い整数への丸めのオプション引数として（[`round`](@ref)関数を介して）使用される型です。

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

