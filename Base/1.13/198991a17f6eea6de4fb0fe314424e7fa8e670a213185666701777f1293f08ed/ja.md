```julia
LazyString <: AbstractString
```

文字列補間を遅延評価する表現です。実際の補間や文字列の構築が不要、または望ましくない状況（関数のエラー処理など）で文字列を構築する場合に便利です。

この型は、実行時の構築コストを抑えるよう設計されています。可能な限り多くの処理をマクロまたは後続の出力処理に委ねます。

# Examples

```jldoctest
julia> n = 5; str = LazyString("n is ", n)
"n is 5"
```

[`@lazy_str`](@ref)も参照してください。

!!! compat "Julia 1.8"
    `LazyString`を使用するには、Julia 1.8以降が必要です。


# Extended help

## Safety properties for concurrent programs

遅延文字列自体は、複数のJuliaタスクで出力しても並行処理上の問題を引き起こしません。ただし、キャプチャされた値に対する`print`メソッドが、同期なしで呼び出された場合に並行処理上の問題を起こし得るなら、遅延文字列の出力によって問題が発生することがあります。また、キャプチャされた値に対する`print`メソッドは複数回呼び出されることがありますが、返される結果は必ず1つだけです。

!!! compat "Julia 1.9"
    `LazyString`は、Julia 1.9以降では上記の意味で安全です。

