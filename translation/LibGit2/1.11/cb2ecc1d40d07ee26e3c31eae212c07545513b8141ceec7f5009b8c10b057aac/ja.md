```julia
LibGit2.BlameOptions
```

[`git_blame_options`](https://libgit2.org/libgit2/#HEAD/type/git_blame_options) 構造体に対応します。

各フィールドの意味は次のとおりです。

  * `version`: 後で変更される場合に備えた、使用中の構造体のバージョン。現時点では、常に `1` です。
  * `flags`: `Consts.BLAME_NORMAL` または `Consts.BLAME_FIRST_PARENT` のいずれかです（その他の blame フラグは、libgit2 ではまだ実装されていません）。
  * `min_match_characters`: 変更をそのコミットに関連付けるために、コミット内で変更されている必要がある英数字の最小文字数です。デフォルトは 20 です。libgit2 ではまだ実装されていない `Consts.BLAME_*_COPIES` フラグのいずれかを使用した場合にのみ有効です。
  * `newest_commit`: 変更を調べる対象となる、最も新しいコミットの [`GitHash`](@ref) です。
  * `oldest_commit`: 変更を調べる対象となる、最も古いコミットの [`GitHash`](@ref) です。
  * `min_line`: blame の開始位置となるファイルの先頭行です。デフォルトは `1` です。
  * `max_line`: blame の対象となるファイルの最終行です。デフォルトは `0` で、ファイルの最終行を意味します。
