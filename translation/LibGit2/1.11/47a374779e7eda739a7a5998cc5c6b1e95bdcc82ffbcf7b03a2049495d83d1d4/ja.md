```
LibGit2.SignatureStruct
```

アクション署名（例：コミッター、タグ付け者など）。[`git_signature`](https://libgit2.org/libgit2/#HEAD/type/git_signature) 構造体に一致します。

フィールドは次のことを表します：

  * `name`: コミッターまたはコミットの著者のフルネーム。
  * `email`: コミッター/著者に連絡できるメールアドレス。
  * `when`: コミットがリポジトリに作成/コミットされた時を示す [`TimeStruct`](@ref)。
