```julia
LibGit2.tag_create(repo::GitRepo, tag::AbstractString, commit; kwargs...)
```

リポジトリ `repo` のコミット `commit` に、新しい Git タグ `tag`（例: `"v0.5"`）を作成します。

キーワード引数は次のとおりです。

  * `msg::AbstractString=""`: タグのメッセージ。
  * `force::Bool=false`: `true` の場合、既存の参照は上書きされます。
  * `sig::Signature=Signature(repo)`: タグ作成者の署名。
