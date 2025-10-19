```julia
IteratorEltype(itertype::Type) -> IteratorEltype
```

イテレータの型が与えられたとき、次のいずれかの値を返します：

  * `EltypeUnknown()` イテレータによって生成される要素の型が事前に知られていない場合。
  * `HasEltype()` 要素の型が知られており、[`eltype`](@ref) が意味のある値を返す場合。

`HasEltype()` はデフォルトであり、イテレータは [`eltype`](@ref) を実装していると仮定されます。

この特性は、特定の型の結果を事前に割り当てるアルゴリズムと、生成される値の型に基づいて結果の型を選択するアルゴリズムを選択するために一般的に使用されます。

```jldoctest
julia> Base.IteratorEltype(1:5)
Base.HasEltype()
```
