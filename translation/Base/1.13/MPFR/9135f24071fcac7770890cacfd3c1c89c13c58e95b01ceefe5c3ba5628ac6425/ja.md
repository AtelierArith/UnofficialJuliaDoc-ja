```julia
BigFloat(x::Union{Real, AbstractString} [, rounding::RoundingMode=rounding(BigFloat)]; [precision::Integer=precision(BigFloat)])
```

`x`から、精度`precision`の任意精度浮動小数点数を作成します。変換を正確に行えない場合に、結果をどの方向に丸めるかは`rounding`引数で指定します。省略した場合は、現在のグローバル値が使われます。

`BigFloat(x::Real)`は`convert(BigFloat,x)`と同じですが、`x`自体がすでに`BigFloat`の場合は例外です。この場合、精度が現在のグローバル精度に設定された値を返します。一方、`convert`は常に`x`を返します。

`BigFloat(x::AbstractString)`は[`parse`](@ref)と同じです。10進リテラルはパース時に`Float64`へ変換されるため、`BigFloat(2.1)`が期待どおりの結果にならないことがあります。このため、便宜上用意されています。

関連項目:

  * [`@big_str`](@ref)
  * [`rounding`](@ref)および[`setrounding`](@ref)
  * [`precision`](@ref)および[`setprecision`](@ref)

!!! compat "Julia 1.1"
    キーワード引数として`precision`を使うには、Julia 1.1以降が必要です。Julia 1.0では、`precision`は2番目の位置引数です（`BigFloat(x, precision)`）。


# Examples

```jldoctest
julia> BigFloat(2.1) # 2.1 here is a Float64
2.100000000000000088817841970012523233890533447265625

julia> BigFloat("2.1") # the closest BigFloat to 2.1
2.099999999999999999999999999999999999999999999999999999999999999999999999999986

julia> BigFloat("2.1", RoundUp)
2.100000000000000000000000000000000000000000000000000000000000000000000000000021

julia> BigFloat("2.1", RoundUp, precision=128)
2.100000000000000000000000000000000000007
```
