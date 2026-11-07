```julia
LibGit2.isdirty(repo::GitRepo, pathspecs::AbstractString=""; cached::Bool=false)::Bool
```

作業ツリー（`cached=false`の場合）またはインデックス（`cached=true`の場合）で、追跡対象ファイルに変更があったかどうかを確認します。`pathspecs`は、差分オプションの仕様です。

# Examples

```julia
repo = LibGit2.GitRepo(repo_path)
LibGit2.isdirty(repo) # should be false
open(joinpath(repo_path, new_file), "a") do f
    println(f, "here's my cool new file")
end
LibGit2.isdirty(repo) # now true
LibGit2.isdirty(repo, new_file) # now true
```

`git diff-index HEAD [-- <pathspecs>]`と同等です。
