```julia
IteratorSize(itertype::Type)::IteratorSize
```

イテレータの型を指定すると、次のいずれかの値を返します。

  * 長さ（要素数）を事前に特定できない場合は、`SizeUnknown()`。
  * 長さが有限かつ固定の場合は、`HasLength()`。
  * 長さが既知で、配列のように多次元の形状も持つ場合は、`HasShape{N}()`。この場合、次元数は`N`で示され、イテレータに対して[`axes`](@ref)関数が有効です。
  * イテレータが値を無限に生成する場合は、`IsInfinite()`。

この関数を定義していないイテレータのデフォルト値は、`HasLength()`です。つまり、ほとんどのイテレータは[`length`](@ref)を実装すると想定されます。

この特性は一般に、結果用の領域を事前に確保するアルゴリズムと、結果のサイズを段階的に変更するアルゴリズムを使い分けるために使用されます。

```jldoctest
julia> Base.IteratorSize(1:5)
Base.HasShape{1}()

julia> Base.IteratorSize((2,3))
Base.HasLength()
```
