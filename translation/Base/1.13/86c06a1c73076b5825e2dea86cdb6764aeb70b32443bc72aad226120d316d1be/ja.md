```julia
Base.reduce_empty(op, T)
```

要素型が `T` の空配列に対して、`op` による reduction を行う際に、[`reduce`](@ref)、[`foldl`](@ref)、または [`foldr`](@ref) を呼び出したときに返される値です。

これは、曖昧さのない場合にのみ定義すべきです。たとえば、

```julia
Base.reduce_empty(::typeof(+), ::Type{T}) where T = zero(T)
```

は妥当です（要素が 0 個の和は 0 です）が、`reduce_empty(::typeof(max), ::Type{Any})` は妥当ではありません（空のコレクションの最大値は一般に曖昧であり、要素型が不明な場合は特にそうです）。

代わりに、reducer に `init` の値を渡すことを検討してください。
