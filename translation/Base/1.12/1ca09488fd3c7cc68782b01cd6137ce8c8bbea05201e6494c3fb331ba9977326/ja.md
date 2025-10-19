```julia
lazy"str"
```

通常の文字列補間構文を使用して[`LazyString`](@ref)を作成します。補間はLazyStringの構築時に*評価*されますが、文字列への最初のアクセスまで*印刷*は遅延されます。

[`LazyString`](@ref)のドキュメントを参照して、同時プログラムの安全性に関するプロパティを確認してください。

# 例

```julia
julia> n = 5; str = lazy"n is $n"
"n is 5"

julia> typeof(str)
LazyString
```

!!! compat "Julia 1.8"
    `lazy"str"`はJulia 1.8以降が必要です。

