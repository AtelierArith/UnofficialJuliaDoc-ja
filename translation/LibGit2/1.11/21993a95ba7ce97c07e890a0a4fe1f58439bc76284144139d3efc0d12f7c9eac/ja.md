```julia
LibGit2.cherrypick(repo::GitRepo, commit::GitCommit; options::CherrypickOptions = CherrypickOptions())
```

コミット `commit` をチェリーピックし、その変更を現在の `repo` の状態に適用します。キーワード引数 `options` は、チェリーピック時のチェックアウトおよびマージのオプションを設定します。

!!! note
    `cherrypick` は `commit` の変更を*適用*しますが、*コミット*はしないため、`repo` は変更のある状態になります。`commit` の変更もコミットする場合は、自分で [`commit`](@ref) を呼び出す必要があります。

