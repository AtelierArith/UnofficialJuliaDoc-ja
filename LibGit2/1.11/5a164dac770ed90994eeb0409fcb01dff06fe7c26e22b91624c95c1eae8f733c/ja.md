```julia
peel([T,] ref::GitReference)
```

`ref` を再帰的に剥がし、`T` 型のオブジェクトを取得します。`T` が指定されていない場合は、`ref` を剥がし、[`GitTag`](@ref) 以外のオブジェクトを取得します。

  * `GitTag` は、それが参照するオブジェクトまで剥がされます。
  * [`GitCommit`](@ref) は、[`GitTree`](@ref) まで剥がされます。

!!! note
    注釈付きタグのみ、`GitTag` オブジェクトまで剥がすことができます。軽量タグ（デフォルト）は、`refs/tags/` の下にある参照で、`GitCommit` オブジェクトを直接指します。

