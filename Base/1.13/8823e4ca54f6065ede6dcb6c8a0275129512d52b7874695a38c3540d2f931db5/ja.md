```julia
lazy"str"
```

通常の文字列補間構文を使って[`LazyString`](@ref)を作成します。補間はLazyStringの構築時に*評価*されますが、文字列の*出力*は、文字列に初めてアクセスするまで遅延される点に注意してください。

並行プログラムにおける安全性については、[`LazyString`](@ref)のドキュメントを参照してください。

# Examples

```julia
julia> n = 5; str = lazy"n is $n"
"n is 5"

julia> typeof(str)
LazyString
```

!!! compat "Julia 1.8"
    `lazy"str"`にはJulia 1.8以降が必要です。

