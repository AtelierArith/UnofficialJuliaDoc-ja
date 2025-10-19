```julia
LibGit2.status(repo::GitRepo, path::String) -> Union{Cuint, Cvoid}
```

`repo`内の`path`にあるファイルのステータスを調べます。たとえば、`path`にあるファイルが変更されており、ステージングおよびコミットが必要かどうかを確認するために使用できます。
