```
RoundingMode
```

浮動小数点演算の丸めモードを制御するために使用される型（[`rounding`](@ref)/[`setrounding`](@ref) 関数を介して）、または最も近い整数に丸めるためのオプション引数として（[`round`](@ref) 関数を介して）。

現在サポートされている丸めモードは次のとおりです：

  * [`RoundNearest`](@ref)（デフォルト）
  * [`RoundNearestTiesAway`](@ref)
  * [`RoundNearestTiesUp`](@ref)
  * [`RoundToZero`](@ref)
  * [`RoundFromZero`](@ref)
  * [`RoundUp`](@ref)
  * [`RoundDown`](@ref)

!!! compat "Julia 1.9"
    `RoundFromZero` は少なくとも Julia 1.9 が必要です。以前のバージョンは `BigFloat` のみのために `RoundFromZero` をサポートしています。

