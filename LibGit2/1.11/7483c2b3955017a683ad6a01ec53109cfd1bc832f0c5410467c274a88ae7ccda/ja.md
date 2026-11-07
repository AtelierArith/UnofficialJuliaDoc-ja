```julia
LibGit2.SignatureStruct
```

コミッターやタグ作成者などのアクション署名です。[`git_signature`](https://libgit2.org/libgit2/#HEAD/type/git_signature) 構造体に対応します。

各フィールドの意味は次のとおりです。

  * `name`: コミッターまたはコミットの作成者の氏名。
  * `email`: コミッターまたは作成者への連絡に使用するメールアドレス。
  * `when`: コミットが作成された時刻、またはリポジトリにコミットされた時刻を示す [`TimeStruct`](@ref)。
