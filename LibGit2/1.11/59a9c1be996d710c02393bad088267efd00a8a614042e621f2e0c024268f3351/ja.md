```
LibGit2.isdiff(repo::GitRepo, treeish::AbstractString, pathspecs::AbstractString=""; cached::Bool=false)
```

`treeish`で指定されたツリーと作業ツリー内の追跡ファイル（`cached=false`の場合）またはインデックス（`cached=true`の場合）との間に違いがあるかどうかをチェックします。`pathspecs`はdiffのオプションの仕様です。

# 例

```julia
repo = LibGit2.GitRepo(repo_path)
LibGit2.isdiff(repo, "HEAD") # falseであるべき
open(joinpath(repo_path, new_file), "a") do f
    println(f, "ここに私のクールな新しいファイルがあります")
end
LibGit2.isdiff(repo, "HEAD") # 今はtrue
```

`git diff-index <treeish> [-- <pathspecs>]`に相当します。
