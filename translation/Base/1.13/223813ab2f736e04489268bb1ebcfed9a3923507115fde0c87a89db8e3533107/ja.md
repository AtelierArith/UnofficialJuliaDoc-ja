```julia
IteratorSize(itertype::Type)::IteratorSize
```

イテレータの型を指定すると、次のいずれかの値を返します。

  * `SizeUnknown()` 要素数を事前に特定できない場合。
  * `HasLength()` 長さが有限かつ固定の場合。
  * `HasShape{N}()` 配列のように、長さが既知で多次元の形状を持つ場合。この場合、`N` は次元数を返し、イテレータに対して [`axes`](@ref) 関数が有効です。
  * `IsInfinite()` イテレータが値を無限に生成する場合。

この関数を定義していないイテレータのデフォルト値は `HasLength()` です。つまり、ほとんどのイテレータは [`length`](@ref) を実装しているものとみなされます。

この特性は一般に、結果の領域を事前に確保するアルゴリズムと、結果を段階的に拡張するアルゴリズムを選択するために使われます。

```jldoctest
julia> Base.IteratorSize(1:5)
Base.HasShape{1}()

julia> Base.IteratorSize((2,3))
Base.HasLength()
```
