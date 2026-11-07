```julia
peel([T,] obj::GitObject)
```

`obj` を再帰的に剥がし、`T` 型のオブジェクトが得られるまで続けます。`T` が指定されていない場合は、型が変わるまで `obj` を剥がします。

  * `GitTag` は、参照先のオブジェクトまで剥がされます。
  * `GitCommit` は、`GitTree` まで剥がされます。
