```
LibGit2.isdirty(repo::GitRepo, pathspecs::AbstractString=""; cached::Bool=false) -> Bool
```

作業ツリー内の追跡ファイルに変更があったかどうかを確認します（`cached=false`の場合）またはインデックス内（`cached=true`の場合）。`pathspecs`はdiffのオプションの仕様です。

# 例

```julia
repo = LibGit2.GitRepo(repo_path)
LibGit2.isdirty(repo) # falseであるべき
open(joinpath(repo_path, new_file), "a") do f
    println(f, "ここに私のクールな新しいファイルがあります")
end
LibGit2.isdirty(repo) # 今はtrue
LibGit2.isdirty(repo, new_file) # 今はtrue
```

`git diff-index HEAD [-- <pathspecs>]`と同等です。
