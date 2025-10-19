```julia
LibGit2.StatusOptions
```

`git_status_foreach_ext()` がコールバックを発行する方法を制御するオプション。 [`git_status_opt_t`](https://libgit2.org/libgit2/#HEAD/type/git_status_opt_t) 構造体に一致します。

フィールドは次のことを表します：

  * `version`: 使用中の構造体のバージョン。今のところ、常に `1` です。
  * `show`: 調べるファイルとその順序を指定するフラグ。デフォルトは `Consts.STATUS_SHOW_INDEX_AND_WORKDIR` です。
  * `flags`: ステータス呼び出しで使用されるコールバックを制御するためのフラグ。
  * `pathspec`: パスマッチングに使用するパスの配列。パスマッチングの動作は、`show` と `flags` の値によって異なります。
  * `baseline` は、作業ディレクトリとインデックスと比較するために使用されるツリーです。デフォルトは HEAD です。
