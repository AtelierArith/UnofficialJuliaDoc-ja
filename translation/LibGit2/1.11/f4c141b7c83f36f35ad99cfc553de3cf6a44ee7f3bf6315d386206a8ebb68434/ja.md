```julia
diff_files(repo::GitRepo, branch1::AbstractString, branch2::AbstractString; kwarg...)::Vector{AbstractString}
```

ブランチ `branch1` と `branch2` の間で、Git リポジトリ `repo` 内の変更されたファイルを表示します。

キーワード引数は次のとおりです。

  * `filter::Set{Consts.DELTA_STATUS}=Set([Consts.DELTA_ADDED, Consts.DELTA_MODIFIED, Consts.DELTA_DELETED]))`。差分のオプションを指定します。デフォルトでは、追加、変更、削除されたファイルが表示されます。

変更されたファイルの内容ではなく、ファイル名のみを返します。

# Examples

```julia
LibGit2.branch!(repo, "branch/a")
LibGit2.branch!(repo, "branch/b")
# add a file to repo
open(joinpath(LibGit2.path(repo),"file"),"w") do f
    write(f, "hello repo
")
end
LibGit2.add!(repo, "file")
LibGit2.commit(repo, "add file")
# returns ["file"]
filt = Set([LibGit2.Consts.DELTA_ADDED])
files = LibGit2.diff_files(repo, "branch/a", "branch/b", filter=filt)
# returns [] because existing files weren't modified
filt = Set([LibGit2.Consts.DELTA_MODIFIED])
files = LibGit2.diff_files(repo, "branch/a", "branch/b", filter=filt)
```

`git diff --name-only --diff-filter=<filter> <branch1> <branch2>` と同等です。
