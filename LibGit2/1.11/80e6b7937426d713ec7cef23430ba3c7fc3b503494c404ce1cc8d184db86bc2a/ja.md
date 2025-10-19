```julia
LibGit2.init(path::AbstractString, bare::Bool=false) -> GitRepo
```

`path`に新しいgitリポジトリを開きます。`bare`が`false`の場合、作業ツリーは`path/.git`に作成されます。`bare`が`true`の場合、作業ディレクトリは作成されません。
