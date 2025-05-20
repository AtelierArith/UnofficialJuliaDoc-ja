```
LibGit2.GitRepoExt(path::AbstractString, flags::Cuint = Cuint(Consts.REPOSITORY_OPEN_DEFAULT))
```

`path`でgitリポジトリを開き、拡張コントロールを使用します（たとえば、現在のユーザーが`path`を読み取るために特別なアクセスグループのメンバーである必要がある場合）。
