```
Channel{T=Any}(size::Int=0)
```

`T`型の最大`size`個のオブジェクトを保持できる内部バッファを持つ`Channel`を構築します。 [`put!`](@ref)が満杯のチャネルで呼び出されると、[`take!`](@ref)でオブジェクトが削除されるまでブロックします。

`Channel(0)`はバッファなしのチャネルを構築します。`put!`は対応する`take!`が呼ばれるまでブロックします。そしてその逆も同様です。

他のコンストラクタ:

  * `Channel()`: デフォルトコンストラクタで、`Channel{Any}(0)`と同等です。
  * `Channel(Inf)`: `Channel{Any}(typemax(Int))`と同等です。
  * `Channel(sz)`: `Channel{Any}(sz)`と同等です。

!!! compat "Julia 1.3"
    デフォルトコンストラクタ`Channel()`とデフォルト`size=0`はJulia 1.3で追加されました。

