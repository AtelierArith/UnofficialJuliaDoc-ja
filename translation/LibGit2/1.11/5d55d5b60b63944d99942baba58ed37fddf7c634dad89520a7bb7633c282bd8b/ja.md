```julia
LibGit2.read_tree!(idx::GitIndex, tree::GitTree)
LibGit2.read_tree!(idx::GitIndex, treehash::AbstractGitHash)
```

インデックス `idx` にツリー `tree` （または `idx` が所有するリポジトリ内の `treehash` が指すツリー）を読み込みます。現在のインデックスの内容は置き換えられます。
