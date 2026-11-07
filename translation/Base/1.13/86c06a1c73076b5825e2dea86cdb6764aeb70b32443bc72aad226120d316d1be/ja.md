```julia
Base.reduce_empty(op, T)
```

要素型が`T`の空配列に対して、`op`によるリダクションを行い、[`reduce`](@ref)、[`foldl`](@ref)、または[`foldr`](@ref)を呼び出したときに返される値。

これは、曖昧さのない場合にのみ定義すべきです。たとえば、

```julia
Base.reduce_empty(::typeof(+), ::Type{T}) where T = zero(T)
```

は妥当です（要素が0個の和は0です）。一方、`reduce_empty(::typeof(max), ::Type{Any})`は妥当ではありません（空のコレクションの最大値は一般に曖昧であり、特に要素型が不明な場合はそうです）。

代わりに、リデューサーに`init`値を渡すことを検討してください。
