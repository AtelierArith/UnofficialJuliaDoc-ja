```julia
isshallow(repo::GitRepo)::Bool
```

`repo` がシャロークローンかどうかを判定します。シャロークローンとは、特定の深さ（例: `LibGit2.clone(url, path, depth=1)`）を指定してクローンすることで、履歴が途中までに制限されたクローンです。

# Examples

```julia
shallow_repo = LibGit2.clone(url, "shallow_path", depth=1)
LibGit2.isshallow(shallow_repo)  # returns true

normal_repo = LibGit2.clone(url, "normal_path")
LibGit2.isshallow(normal_repo)  # returns false
```
