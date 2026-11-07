```julia
LibGit2.read_tree!(idx::GitIndex, tree::GitTree)
LibGit2.read_tree!(idx::GitIndex, treehash::AbstractGitHash)
```

ツリー `tree`（または、`idx` が所有するリポジトリ内で `treehash` が指すツリー）をインデックス `idx` に読み込みます。現在のインデックスの内容は置き換えられます。
