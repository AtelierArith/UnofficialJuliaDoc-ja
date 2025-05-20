```
AbstractGitObject
```

`AbstractGitObject`は以下のインターフェースに従わなければなりません：

  * `obj.owner`が存在する場合、`Union{Nothing,GitRepo,GitTree}`でなければなりません
  * `obj.ptr`が存在する場合、`Union{Ptr{Cvoid},Ptr{SignatureStruct}}`でなければなりません
