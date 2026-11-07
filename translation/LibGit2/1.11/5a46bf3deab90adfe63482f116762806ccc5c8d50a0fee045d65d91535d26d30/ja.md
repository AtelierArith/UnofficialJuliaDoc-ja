```julia
LibGit2.headname(repo::GitRepo)
```

git リポジトリ `repo` の現在の HEAD の名前を取得します。`repo` が現在 detached 状態の場合は、HEAD がどの名前から切り離されているかを返します。
