```julia
LibGit2.init(path::AbstractString, bare::Bool=false)::GitRepo
```

`path` に新しい Git リポジトリを作成します。`bare` が `false` の場合、作業ツリーは `path/.git` に作成されます。`bare` が `true` の場合、作業ディレクトリは作成されません。
