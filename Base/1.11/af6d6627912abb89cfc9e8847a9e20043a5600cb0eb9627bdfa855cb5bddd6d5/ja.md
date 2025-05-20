```
IteratorSize(itertype::Type) -> IteratorSize
```

イテレータの型を与えると、次のいずれかの値を返します：

  * `SizeUnknown()` もし長さ（要素の数）が事前に決定できない場合。
  * `HasLength()` もし固定された有限の長さがある場合。
  * `HasShape{N}()` もし既知の長さに加えて多次元の形状の概念がある場合（配列のように）。この場合、`N` は次元の数を示し、[`axes`](@ref) 関数はイテレータに対して有効です。
  * `IsInfinite()` もしイテレータが永遠に値を生成する場合。

この関数を定義していないイテレータのデフォルト値は `HasLength()` です。これは、ほとんどのイテレータが [`length`](@ref) を実装していると仮定されることを意味します。

この特性は、結果のためにスペースを事前に割り当てるアルゴリズムと、結果を段階的にサイズ変更するアルゴリズムを選択するために一般的に使用されます。

```jldoctest
julia> Base.IteratorSize(1:5)
Base.HasShape{1}()

julia> Base.IteratorSize((2,3))
Base.HasLength()
```
