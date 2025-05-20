```
LibGit2.StatusOptions
```

`git_status_foreach_ext()` がコールバックを発行する方法を制御するオプション。 [`git_status_opt_t`](https://libgit2.org/libgit2/#HEAD/type/git_status_opt_t) 構造体に一致します。

フィールドは次のことを表します：

  * `version`: 後で変更される場合に備えて、使用中の構造体のバージョン。現時点では常に `1`。
  * `show`: 検査するファイルとその順序を指定するフラグ。デフォルトは `Consts.STATUS_SHOW_INDEX_AND_WORKDIR`。
  * `flags`: ステータス呼び出しで使用されるコールバックを制御するためのフラグ。
  * `pathspec`: パスマッチングに使用するパスの配列。パスマッチングの動作は、`show` と `flags` の値によって異なります。
  * `baseline`: 作業ディレクトリとインデックスと比較するために使用されるツリー; デフォルトは HEAD。
