```
BigFloat(x::Union{Real, AbstractString} [, rounding::RoundingMode=rounding(BigFloat)]; [precision::Integer=precision(BigFloat)])
```

`x`から任意の精度の浮動小数点数を作成します。`precision`は精度を指定します。`rounding`引数は、変換が正確に行えない場合に結果がどの方向に丸められるべきかを指定します。指定しない場合、これらは現在のグローバル値によって設定されます。

`BigFloat(x::Real)`は`convert(BigFloat,x)`と同じですが、`x`自体がすでに`BigFloat`である場合は、現在のグローバル精度に設定された値を返します。`convert`は常に`x`を返します。

`BigFloat(x::AbstractString)`は[`parse`](@ref)と同じです。これは、10進数リテラルが解析時に`Float64`に変換されるため、便利のために提供されています。したがって、`BigFloat(2.1)`は期待通りの結果を得られないかもしれません。

参照：

  * [`@big_str`](@ref)
  * [`rounding`](@ref)および[`setrounding`](@ref)
  * [`precision`](@ref)および[`setprecision`](@ref)

!!! compat "Julia 1.1"
    `precision`をキーワード引数として使用するには、少なくともJulia 1.1が必要です。Julia 1.0では`precision`は2番目の位置引数です（`BigFloat(x, precision)`）。


# 例

```jldoctest
julia> BigFloat(2.1) # ここでの2.1はFloat64です
2.100000000000000088817841970012523233890533447265625

julia> BigFloat("2.1") # 2.1に最も近いBigFloat
2.099999999999999999999999999999999999999999999999999999999999999999999999999986

julia> BigFloat("2.1", RoundUp)
2.100000000000000000000000000000000000000000000000000000000000000000000000000021

julia> BigFloat("2.1", RoundUp, precision=128)
2.100000000000000000000000000000000000007
```
