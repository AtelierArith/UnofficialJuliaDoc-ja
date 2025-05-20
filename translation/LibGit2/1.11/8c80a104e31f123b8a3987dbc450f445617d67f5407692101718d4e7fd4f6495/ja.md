```
LibGit2.CherrypickOptions
```

[`git_cherrypick_options`](https://libgit2.org/libgit2/#HEAD/type/git_cherrypick_options) 構造体に対応しています。

フィールドは次のことを表します：

  * `version`: 使用中の構造体のバージョン。将来的に変更される場合に備えています。現時点では常に `1` です。
  * `mainline`: マージコミットをチェリーピックする場合、チェリーピックがその親に対して変更を適用できるようにする親番号（`1` から始まる）を指定します。マージコミットをチェリーピックする場合にのみ関連します。デフォルトは `0` です。
  * `merge_opts`: 変更をマージするためのオプションです。詳細については [`MergeOptions`](@ref) を参照してください。
  * `checkout_opts`: チェリーピックされるコミットのチェックアウトに関するオプションです。詳細については [`CheckoutOptions`](@ref) を参照してください。
