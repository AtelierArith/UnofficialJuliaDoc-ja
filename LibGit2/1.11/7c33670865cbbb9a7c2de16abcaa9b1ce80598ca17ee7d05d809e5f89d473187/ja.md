```julia
diff_files(repo::GitRepo, branch1::AbstractString, branch2::AbstractString; kwarg...) -> Vector{AbstractString}
```

gitリポジトリ`repo`において、ブランチ`branch1`と`branch2`の間で変更されたファイルを表示します。

キーワード引数は次の通りです：

  * `filter::Set{Consts.DELTA_STATUS}=Set([Consts.DELTA_ADDED, Consts.DELTA_MODIFIED, Consts.DELTA_DELETED]))`で、diffのオプションを設定します。デフォルトは追加、変更、または削除されたファイルを表示します。

変更されたファイルの*名前*のみを返し、*内容*は返しません。

# 例

```julia
LibGit2.branch!(repo, "branch/a")
LibGit2.branch!(repo, "branch/b")
# repoにファイルを追加
open(joinpath(LibGit2.path(repo),"file"),"w") do f
    write(f, "hello repo
")
end
LibGit2.add!(repo, "file")
LibGit2.commit(repo, "add file")
# returns ["file"]
filt = Set([LibGit2.Consts.DELTA_ADDED])
files = LibGit2.diff_files(repo, "branch/a", "branch/b", filter=filt)
# returns [] 既存のファイルは変更されていないため
filt = Set([LibGit2.Consts.DELTA_MODIFIED])
files = LibGit2.diff_files(repo, "branch/a", "branch/b", filter=filt)
```

`git diff --name-only --diff-filter=<filter> <branch1> <branch2>`と同等です。
