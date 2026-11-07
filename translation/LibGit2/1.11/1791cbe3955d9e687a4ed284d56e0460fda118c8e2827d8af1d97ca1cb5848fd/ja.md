```julia
LibGit2.status(repo::GitRepo, path::String)::Union{Cuint, Cvoid}
```

git リポジトリ `repo` 内のファイル `path` の状態を確認します。たとえば、`path` のファイルが変更されており、ステージングしてコミットする必要があるかどうかを確認できます。
