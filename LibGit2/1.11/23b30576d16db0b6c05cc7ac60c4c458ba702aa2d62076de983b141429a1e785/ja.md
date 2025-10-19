```julia
checkout!(repo::GitRepo, commit::AbstractString=""; force::Bool=true)
```

`git checkout [-f] --detach <commit>` と同等です。`repo` で git コミット `commit`（文字列形式の [`GitHash`](@ref））をチェックアウトします。`force` が `true` の場合、チェックアウトを強制し、現在の変更を破棄します。これは現在の HEAD をデタッチすることに注意してください。

# 例

```julia
repo = LibGit2.GitRepo(repo_path)
open(joinpath(LibGit2.path(repo), "file1"), "w") do f
    write(f, "111
")
end
LibGit2.add!(repo, "file1")
commit_oid = LibGit2.commit(repo, "add file1")
open(joinpath(LibGit2.path(repo), "file1"), "w") do f
    write(f, "112
")
end
# force=true がないと失敗します
# ファイルに変更があるため
LibGit2.checkout!(repo, string(commit_oid), force=true)
```
