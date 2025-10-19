```julia
LibGit2.workdir(repo::GitRepo)
```

`repo`の作業ディレクトリの場所を返します。これはベアリポジトリに対してはエラーをスローします。

!!! note
    これは通常、`gitdir(repo)`の親ディレクトリになりますが、いくつかのケースでは異なる場合があります：例えば、`core.worktree`設定変数または`GIT_WORK_TREE`環境変数のいずれかが設定されている場合です。


[`gitdir`](@ref)や[`path`](@ref)も参照してください。
