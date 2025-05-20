```
reset!(repo::GitRepo, id::GitHash, mode::Cint=Consts.RESET_MIXED)
```

リポジトリ `repo` を `id` の状態にリセットし、`mode` で設定された3つのモードのいずれかを使用します：

1. `Consts.RESET_SOFT` - HEADを `id` に移動します。
2. `Consts.RESET_MIXED` - デフォルト、HEADを `id` に移動し、インデックスを `id` にリセットします。
3. `Consts.RESET_HARD` - HEADを `id` に移動し、インデックスを `id` にリセットし、すべての作業中の変更を破棄します。

# 例

```julia
# 変更を取得
LibGit2.fetch(repo)
isfile(joinpath(repo_path, our_file)) # false になります

# 変更をファストフォワードマージ
LibGit2.merge!(repo, fastforward=true)

# ローカルにファイルがなかったため、リモートに
# ファイルがある場合、ブランチをリセットする必要があります
head_oid = LibGit2.head_oid(repo)
new_head = LibGit2.reset!(repo, head_oid, LibGit2.Consts.RESET_HARD)
```

この例では、フェッチ元のリモートにはインデックスに `our_file` というファイルが存在するため、リセットする必要があります。

`git reset [--soft | --mixed | --hard] <id>` と同等です。

# 例

```julia
repo = LibGit2.GitRepo(repo_path)
head_oid = LibGit2.head_oid(repo)
open(joinpath(repo_path, "file1"), "w") do f
    write(f, "111
")
end
LibGit2.add!(repo, "file1")
mode = LibGit2.Consts.RESET_HARD
# file1への変更を破棄し
# ステージから外します
new_head = LibGit2.reset!(repo, head_oid, mode)
```
