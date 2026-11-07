```julia
LazyString <: AbstractString
```

文字列補間を遅延評価する表現です。実際の補間や文字列の構築が不要、または望ましくない状況（関数のエラー処理など）で文字列を構築する場合に便利です。

この型は、実行時の構築コストを抑えるよう設計されており、できる限り多くの処理をマクロまたは後続の出力処理に委ねます。

# Examples

```jldoctest
julia> n = 5; str = LazyString("n is ", n)
"n is 5"
```

関連項目：[`@lazy_str`](@ref)。

!!! compat "Julia 1.8"
    `LazyString`にはJulia 1.8以降が必要です。


# Extended help

## Safety properties for concurrent programs

遅延文字列自体は、複数のJuliaタスクで出力しても並行処理上の問題を引き起こしません。ただし、キャプチャされた値に対する`print`メソッドが、同期なしで呼び出された場合に並行処理上の問題を起こす可能性があるなら、遅延文字列の出力によって問題が発生することがあります。また、キャプチャされた値に対する`print`メソッドは複数回呼び出されることがありますが、返される結果は必ず1つだけです。

!!! compat "Julia 1.9"
    上記の意味で`LazyString`が安全なのは、Julia 1.9以降です。

