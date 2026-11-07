```julia
reset!(repo::GitRepo, id::GitHash, mode::Cint=Consts.RESET_MIXED)
```

リポジトリ `repo` を `id` の状態に戻します。モードは `mode` で指定する次の3つから選びます。

1. `Consts.RESET_SOFT` - HEAD を `id` に移動します。
2. `Consts.RESET_MIXED` - デフォルト。HEAD を `id` に移動し、インデックスを `id` にリセットします。
3. `Consts.RESET_HARD` - HEAD を `id` に移動し、インデックスを `id` にリセットして、作業ツリーの変更をすべて破棄します。

# Examples

```julia
# fetch changes
LibGit2.fetch(repo)
isfile(joinpath(repo_path, our_file)) # will be false

# fastforward merge the changes
LibGit2.merge!(repo, fastforward=true)

# because there was not any file locally, but there is
# a file remotely, we need to reset the branch
head_oid = LibGit2.head_oid(repo)
new_head = LibGit2.reset!(repo, head_oid, LibGit2.Consts.RESET_HARD)
```

この例では、フェッチ元のリモートのインデックスに `our_file` というファイルが存在するため、リセットが必要です。

`git reset [--soft | --mixed | --hard] <id>` と同等です。

# Examples

```julia
repo = LibGit2.GitRepo(repo_path)
head_oid = LibGit2.head_oid(repo)
open(joinpath(repo_path, "file1"), "w") do f
    write(f, "111
")
end
LibGit2.add!(repo, "file1")
mode = LibGit2.Consts.RESET_HARD
# will discard the changes to file1
# and unstage it
new_head = LibGit2.reset!(repo, head_oid, mode)
```
