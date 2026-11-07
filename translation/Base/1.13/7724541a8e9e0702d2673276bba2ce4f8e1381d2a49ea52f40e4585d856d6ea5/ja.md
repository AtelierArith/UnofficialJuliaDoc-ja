```julia
IteratorEltype(itertype::Type)::IteratorEltype
```

イテレータの型を指定すると、次のいずれかの値を返します。

  * イテレータが生成する要素の型が事前にわからない場合は、`EltypeUnknown()`。
  * 要素の型が既知であり、[`eltype`](@ref)が意味のある値を返す場合は、`HasEltype()`。

イテレータは[`eltype`](@ref)を実装しているものと想定されるため、`HasEltype()`がデフォルトです。

このトレイトは一般に、特定の型の結果を事前に確保するアルゴリズムと、生成された値の型に基づいて結果の型を選ぶアルゴリズムを切り替えるために使われます。

```jldoctest
julia> Base.IteratorEltype(1:5)
Base.HasEltype()
```
