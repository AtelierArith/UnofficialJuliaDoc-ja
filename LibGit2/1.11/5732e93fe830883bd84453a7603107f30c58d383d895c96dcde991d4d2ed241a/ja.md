```julia
LibGit2.GitRepoExt(path::AbstractString, flags::Cuint = Cuint(Consts.REPOSITORY_OPEN_DEFAULT))
```

`path` で、アクセス制御を強化した Git リポジトリを開きます（たとえば、`path` を読み取るには、現在のユーザーが特別なアクセスグループのメンバーである必要がある場合など）。
