```julia
LibGit2.head!(repo::GitRepo, ref::GitReference)::GitReference
```

`repo` の HEAD を、`ref` が指すオブジェクトに設定します。
