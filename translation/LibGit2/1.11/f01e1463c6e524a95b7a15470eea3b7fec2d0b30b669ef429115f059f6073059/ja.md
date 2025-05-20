```
LibGit2.status(repo::GitRepo, path::String) -> Union{Cuint, Cvoid}
```

`repo`のgitリポジトリ内の`path`にあるファイルのステータスを確認します。たとえば、`path`にあるファイルが変更されており、ステージングおよびコミットが必要かどうかを確認するために使用できます。
