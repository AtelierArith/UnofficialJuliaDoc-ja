```julia
Channel{T=Any}(size::Int=0)
```

内部バッファに、型 `T` のオブジェクトを最大 `size` 個まで保持できる `Channel` を構築します。チャネルが満杯の場合、[`put!`](@ref) の呼び出しは、[`take!`](@ref) によってオブジェクトが取り出されるまでブロックします。

`Channel(0)` は、バッファなしのチャネルを構築します。対応する `take!` が呼び出されるまで、`put!` はブロックします。その逆も同様です。

その他のコンストラクター:

  * `Channel()`: デフォルトのコンストラクター。`Channel{Any}(0)` と同等です。
  * `Channel(Inf)`: `Channel{Any}(typemax(Int))` と同等です。
  * `Channel(sz)`: `Channel{Any}(sz)` と同等です。

!!! compat "Julia 1.3"
    デフォルトのコンストラクター `Channel()` と、デフォルトの `size=0` は、Julia 1.3 で追加されました。

