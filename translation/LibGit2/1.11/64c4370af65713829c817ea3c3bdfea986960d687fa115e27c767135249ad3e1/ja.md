```julia
LibGit2.GitStatus(repo::GitRepo; status_opts=StatusOptions())
```

git リポジトリ `repo` 内の各ファイルの状態（変更済みか、ステージ済みかなど）を取得します。`status_opts` を使うと、未追跡ファイルを確認するかどうか、サブモジュールを含めるかどうかなど、さまざまなオプションを設定できます。詳しくは [`StatusOptions`](@ref) を参照してください。
