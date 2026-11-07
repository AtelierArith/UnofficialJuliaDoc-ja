```julia
LibGit2.create_branch(repo::GitRepo, bname::AbstractString, commit_obj::GitCommit; force::Bool=false)
```

リポジトリ `repo` に、コミット `commit_obj`（`repo` に含まれている必要があります）を指す、名前が `bname` の新しいブランチを作成します。`force` が `true` の場合、同名の既存ブランチ `bname` があれば上書きします。`force` が `false` で、同名のブランチ `bname` がすでに存在する場合、この関数はエラーをスローします。
