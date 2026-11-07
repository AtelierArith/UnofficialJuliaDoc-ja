```julia
LibGit2.ApplyOptions
```

差分の適用方法を指定するオプションです。[`git_apply_options`](https://libgit2.org/libgit2/#HEAD/type/git_apply_options) 構造体に対応します。

各フィールドの意味は次のとおりです。

  * `version`: 後で変更される場合に備えた、使用中の構造体のバージョン。現時点では常に `1` です。
  * `delta_cb`: 各差分を適用する前に呼び出される、任意のコールバック。
  * `hunk_cb`: 各ハンクを適用する前に呼び出される、任意のコールバック。
  * `payload`: コールバック関数に渡すペイロード。
  * `flags`: 適用方法を制御するフラグ（チェックモードなど）。
