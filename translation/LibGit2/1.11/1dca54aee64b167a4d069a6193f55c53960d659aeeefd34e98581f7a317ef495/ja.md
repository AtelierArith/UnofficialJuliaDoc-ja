```julia
LibGit2.GitStatus(repo::GitRepo; status_opts=StatusOptions())
```

gitリポジトリ`repo`内の各ファイルのステータスに関する情報を収集します（例：ファイルが変更されたか、ステージされたかなど）。`status_opts`を使用して、追跡されていないファイルを確認するかどうかや、サブモジュールを含めるかどうかなど、さまざまなオプションを設定できます。詳細については[`StatusOptions`](@ref)を参照してください。
