```julia
LibGit2.workdir(repo::GitRepo)
```

`repo` の作業ディレクトリの場所を返します。ベアリポジトリではエラーが発生します。

!!! note
    通常は `gitdir(repo)` の親ディレクトリですが、場合によっては異なることがあります。たとえば、`core.worktree` 設定変数または `GIT_WORK_TREE` 環境変数が設定されている場合です。


関連項目: [`gitdir`](@ref)、[`path`](@ref)。
