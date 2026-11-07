```julia
AbstractGitObject
```

`AbstractGitObject`s は、次のインターフェースに従う必要があります。

  * `obj.owner` が存在する場合は、`Union{Nothing,GitRepo,GitTree}` でなければなりません。
  * `obj.ptr` が存在する場合は、`Union{Ptr{Cvoid},Ptr{SignatureStruct}}` でなければなりません。
