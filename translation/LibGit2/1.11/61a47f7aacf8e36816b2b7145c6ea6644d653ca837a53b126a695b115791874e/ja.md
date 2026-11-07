```julia
LibGit2.StatusOptions
```

`git_status_foreach_ext()`がコールバックを呼び出す方法を制御するオプションです。[`git_status_opt_t`](https://libgit2.org/libgit2/#HEAD/type/git_status_opt_t)構造体に対応します。

各フィールドの意味は次のとおりです。

  * `version`: 使用する構造体のバージョンです。将来変更される場合に備えて設けられています。現時点では常に`1`です。
  * `show`: 調査するファイルとその順序を指定するフラグです。デフォルトは`Consts.STATUS_SHOW_INDEX_AND_WORKDIR`です。
  * `flags`: status呼び出しで使用するコールバックを制御するフラグです。
  * `pathspec`: パスの照合に使用するパスの配列です。パス照合の動作は、`show`と`flags`の値によって異なります。
  * `baseline`は、作業ディレクトリおよびインデックスとの比較に使用するツリーです。デフォルトはHEADです。
