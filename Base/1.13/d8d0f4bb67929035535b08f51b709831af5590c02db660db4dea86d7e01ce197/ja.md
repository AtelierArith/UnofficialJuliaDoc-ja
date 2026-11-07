```julia
trunc([T,] x)
trunc(x; digits::Integer= [, base = 10])
trunc(x; sigdigits::Integer= [, base = 10])
```

`trunc(x)` は、`x` の絶対値以下で、絶対値が最も大きい整数値を、`x` と同じ型で返します。

`trunc(T, x)` は、結果を `T` 型に変換します。切り捨てた値を `T` で表現できない場合は、`InexactError` をスローします。

キーワード `digits`、`sigdigits`、`base` の動作は、[`round`](@ref) と同じです。

新しい型で `trunc` をサポートするには、`Base.round(x::NewType, ::RoundingMode{:ToZero})` を定義します。

関連項目: [`%`](@ref rem)、[`floor`](@ref)、[`unsigned`](@ref)、[`unsafe_trunc`](@ref)。

# Examples

```jldoctest
julia> trunc(2.22)
2.0

julia> trunc(-2.22, digits=1)
-2.2

julia> trunc(Int, -2.22)
-2
```
