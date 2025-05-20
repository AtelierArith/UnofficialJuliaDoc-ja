```
AbstractGitObject
```

`AbstractGitObject`s must obey the following interface:

  * `obj.owner`, if present, must be a `Union{Nothing,GitRepo,GitTree}`
  * `obj.ptr`, if present, must be a `Union{Ptr{Cvoid},Ptr{SignatureStruct}}`
