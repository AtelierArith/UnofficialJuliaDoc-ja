```julia
LibGit2.CherrypickOptions
```

[`git_cherrypick_options`](https://libgit2.org/libgit2/#HEAD/type/git_cherrypick_options) 構造体に一致します。

各フィールドの意味は次のとおりです。

  * `version`: 後で変更される場合に備えた、使用中の構造体のバージョン。現時点では、常に `1` です。
  * `mainline`: マージコミットをチェリーピックする場合に、親番号（`1` から始まる）を指定します。これにより、チェリーピックでその親との差分を適用できます。マージコミットをチェリーピックする場合にのみ関係します。デフォルトは `0` です。
  * `merge_opts`: 変更をマージする際のオプション。詳しくは [`MergeOptions`](@ref) を参照してください。
  * `checkout_opts`: チェリーピックするコミットをチェックアウトする際のオプション。詳しくは [`CheckoutOptions`](@ref) を参照してください。
