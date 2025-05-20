```
LibGit2.BlameOptions
```

[`git_blame_options`](https://libgit2.org/libgit2/#HEAD/type/git_blame_options) 構造体に対応しています。

フィールドは次のことを表します：

  * `version`: 使用中の構造体のバージョン。将来的に変更される場合に備えています。現在は常に `1` です。
  * `flags`: `Consts.BLAME_NORMAL` または `Consts.BLAME_FIRST_PARENT` のいずれか（他のブレイムフラグは libgit2 によってまだ実装されていません）。
  * `min_match_characters`: コミットに関連付けるために変更される必要がある *英数字* の最小文字数。デフォルトは 20 です。`Consts.BLAME_*_COPIES` フラグのいずれかが使用されている場合にのみ有効で、libgit2 ではまだ実装されていません。
  * `newest_commit`: 変更を確認するための最新のコミットの [`GitHash`](@ref)。
  * `oldest_commit`: 変更を確認するための最古のコミットの [`GitHash`](@ref)。
  * `min_line`: ブレイミングを開始するファイルの最初の行。デフォルトは `1` です。
  * `max_line`: ブレイムを行うファイルの最後の行。デフォルトは `0` で、ファイルの最後の行を意味します。
