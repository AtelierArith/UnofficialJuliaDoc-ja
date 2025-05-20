```
LibGit2.tag_create(repo::GitRepo, tag::AbstractString, commit; kwargs...)
```

リポジトリ `repo` に新しい git タグ `tag`（例: `"v0.5"`）を、コミット `commit` に作成します。

キーワード引数は次の通りです：

  * `msg::AbstractString=""`: タグのメッセージ。
  * `force::Bool=false`: `true` の場合、既存の参照が上書きされます。
  * `sig::Signature=Signature(repo)`: タグ付け者の署名。
