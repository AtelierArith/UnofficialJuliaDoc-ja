```julia
LibGit2.GitRepoExt(path::AbstractString, flags::Cuint = Cuint(Consts.REPOSITORY_OPEN_DEFAULT))
```

`path` に、拡張アクセス制御を設定して Git リポジトリを開きます（たとえば、`path` を読み取るには、現在のユーザーが特別なアクセスグループのメンバーである必要がある場合など）。
