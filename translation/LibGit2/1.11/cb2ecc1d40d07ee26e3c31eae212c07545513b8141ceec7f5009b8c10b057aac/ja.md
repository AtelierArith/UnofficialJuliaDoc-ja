```julia
LibGit2.BlameOptions
```

[`git_blame_options`](https://libgit2.org/libgit2/#HEAD/type/git_blame_options) 構造体に対応します。

各フィールドの意味は次のとおりです。

  * `version`: 後で変更される場合に備えた、使用中の構造体のバージョン。現時点では、常に `1` です。
  * `flags`: `Consts.BLAME_NORMAL` または `Consts.BLAME_FIRST_PARENT` のいずれか（その他の blame フラグは、libgit2 ではまだ実装されていません）。
  * `min_match_characters`: 変更をそのコミットに関連付けるために、コミット内で変更されている必要がある英数字の最小文字数。デフォルトは 20 です。`Consts.BLAME_*_COPIES` フラグのいずれかを使用した場合にのみ有効になりますが、これらのフラグは libgit2 ではまだ実装されていません。
  * `newest_commit`: 変更を調べる対象となる最新コミットの [`GitHash`](@ref)。
  * `oldest_commit`: 変更を調べる対象となる最古コミットの [`GitHash`](@ref)。
  * `min_line`: blame の開始行となるファイルの先頭行。デフォルトは `1` です。
  * `max_line`: blame の対象となるファイルの最終行。デフォルトは `0` で、ファイルの最終行を意味します。
