```julia
peel([T,] ref::GitReference)
```

`ref`を再帰的に剥がして、型`T`のオブジェクトを取得します。`T`が提供されていない場合、`ref`は[`GitTag`](@ref)以外のオブジェクトが取得されるまで剥がされます。

  * `GitTag`は、それが参照するオブジェクトに剥がされます。
  * [`GitCommit`](@ref)は[`GitTree`](@ref)に剥がされます。

!!! note
    注釈付きタグのみが`GitTag`オブジェクトに剥がすことができます。軽量タグ（デフォルト）は、`GitCommit`オブジェクトに直接ポイントする`refs/tags/`の下の参照です。

