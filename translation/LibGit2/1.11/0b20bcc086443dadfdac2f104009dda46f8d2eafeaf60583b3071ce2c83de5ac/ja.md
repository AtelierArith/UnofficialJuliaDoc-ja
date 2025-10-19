```julia
branch!(repo::GitRepo, branch_name::AbstractString, commit::AbstractString=""; kwargs...)
```

`repo` リポジトリで新しい git ブランチをチェックアウトします。`commit` は新しいブランチの開始点となる文字列形式の [`GitHash`](@ref) です。`commit` が空の文字列の場合、現在の HEAD が使用されます。

キーワード引数は次の通りです：

  * `track::AbstractString=""`: この新しいブランチが追跡すべきリモートブランチの名前。空の場合（デフォルト）、リモートブランチは追跡されません。
  * `force::Bool=false`: `true` の場合、ブランチの作成が強制されます。
  * `set_head::Bool=true`: `true` の場合、ブランチの作成が完了した後、ブランチのヘッドが `repo` の HEAD に設定されます。

`git checkout [-b|-B] <branch_name> [<commit>] [--track <track>]` と同等です。

# 例

```julia
repo = LibGit2.GitRepo(repo_path)
LibGit2.branch!(repo, "new_branch", set_head=false)
```
