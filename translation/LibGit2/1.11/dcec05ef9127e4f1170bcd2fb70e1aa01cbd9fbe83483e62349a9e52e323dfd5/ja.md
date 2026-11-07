```julia
LibGit2.isdiff(repo::GitRepo, treeish::AbstractString, pathspecs::AbstractString=""; cached::Bool=false)
```

`treeish`で指定されたツリーと、作業ツリー内の追跡対象ファイル（`cached=false`の場合）またはインデックス（`cached=true`の場合）との間に差分があるかどうかを確認します。`pathspecs`は、diffのオプションの指定です。

# Examples

```julia
repo = LibGit2.GitRepo(repo_path)
LibGit2.isdiff(repo, "HEAD") # should be false
open(joinpath(repo_path, new_file), "a") do f
    println(f, "here's my cool new file")
end
LibGit2.isdiff(repo, "HEAD") # now true
```

`git diff-index <treeish> [-- <pathspecs>]`と同等です。
