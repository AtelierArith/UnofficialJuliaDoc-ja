```julia
LibGit2.reftype(ref::GitReference)::Cint
```

`ref` の型に対応する `Cint` を返します。

  * 参照が無効な場合は `0`
  * 参照がオブジェクト ID の場合は `1`
  * 参照がシンボリックな場合は `2`
