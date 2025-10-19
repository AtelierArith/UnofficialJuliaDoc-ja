```julia
LibGit2.create_branch(repo::GitRepo, bname::AbstractString, commit_obj::GitCommit; force::Bool=false)
```

リポジトリ `repo` に新しいブランチ `bname` を作成し、コミット `commit_obj` を指します（`commit_obj` は `repo` の一部である必要があります）。`force` が `true` の場合、既存のブランチ `bname` が存在する場合は上書きします。`force` が `false` で、すでに `bname` という名前のブランチが存在する場合、この関数はエラーをスローします。
