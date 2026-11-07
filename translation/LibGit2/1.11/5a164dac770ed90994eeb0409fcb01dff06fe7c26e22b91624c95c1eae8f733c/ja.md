```julia
peel([T,] ref::GitReference)
```

`ref`を再帰的に剥がし、`T`型のオブジェクトを取得します。`T`が指定されていない場合は、[`GitTag`](@ref)以外のオブジェクトが得られるまで、`ref`を剥がします。

  * `GitTag`は、それが参照するオブジェクトまで剥がされます。
  * [`GitCommit`](@ref)は、[`GitTree`](@ref)まで剥がされます。

!!! note
    注釈付きタグのみ、`GitTag`オブジェクトまで剥がすことができます。軽量タグ（デフォルト）は、`GitCommit`オブジェクトを直接指す、`refs/tags/`配下の参照です。

