```
trunc([T,] x)
trunc(x; digits::Integer= [, base = 10])
trunc(x; sigdigits::Integer= [, base = 10])
```

`trunc(x)` は、`x` の絶対値以下の同じ型の最も近い整数値を返します。

`trunc(T, x)` は結果を型 `T` に変換し、切り捨てた値が `T` で表現できない場合は `InexactError` をスローします。

キーワード `digits`、`sigdigits` および `base` は [`round`](@ref) と同様に機能します。

新しい型に対して `trunc` をサポートするには、`Base.round(x::NewType, ::RoundingMode{:ToZero})` を定義します。

関連項目: [`%`](@ref rem)、[`floor`](@ref)、[`unsigned`](@ref)、[`unsafe_trunc`](@ref)。

# 例

```jldoctest
julia> trunc(2.22)
2.0

julia> trunc(-2.22, digits=1)
-2.2

julia> trunc(Int, -2.22)
-2
```
