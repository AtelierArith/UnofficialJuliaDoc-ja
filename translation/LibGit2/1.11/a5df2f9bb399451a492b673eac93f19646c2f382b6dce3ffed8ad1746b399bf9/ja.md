```julia
branch!(repo::GitRepo, branch_name::AbstractString, commit::AbstractString=""; kwargs...)
```

`repo` リポジトリで新しい Git ブランチをチェックアウトします。`commit` は、文字列形式の [`GitHash`](@ref) で、新しいブランチの開始点になります。`commit` が空文字列の場合は、現在の HEAD が使用されます。

キーワード引数は次のとおりです。

  * `track::AbstractString=""`: 新しいブランチが追跡するリモートブランチの名前。空の場合（デフォルト）は、リモートブランチを追跡しません。
  * `force::Bool=false`: `true` の場合、ブランチの作成を強制します。
  * `set_head::Bool=true`: `true` の場合、ブランチの作成後に、そのブランチの HEAD を `repo` の HEAD に設定します。

`git checkout [-b|-B] <branch_name> [<commit>] [--track <track>]` と同等です。

# Examples

```julia
repo = LibGit2.GitRepo(repo_path)
LibGit2.branch!(repo, "new_branch", set_head=false)
```
