```
LibGit2.DiffOptionsStruct
```

は [`git_diff_options`](https://libgit2.org/libgit2/#HEAD/type/git_diff_options) 構造体に対応しています。

フィールドは次のように表します：

  * `version`: 使用中の構造体のバージョン。将来的に変更される場合に備えています。現在は常に `1` です。
  * `flags`: どのファイルが diff に表示されるかを制御するフラグ。デフォルトは `DIFF_NORMAL` です。
  * `ignore_submodules`: サブモジュール内のファイルを確認するかどうか。デフォルトは `SUBMODULE_IGNORE_UNSPECIFIED` で、これはサブモジュールの設定が diff に表示されるかどうかを制御します。
  * `pathspec`: diff に含めるファイルのパス。デフォルトはリポジトリ内のすべてのファイルを使用します。
  * `notify_cb`: ファイルデルタが追加される際に、diff の変更をユーザーに通知するオプションのコールバック。
  * `progress_cb`: diff の進行状況を表示するオプションのコールバック。libgit2 のバージョンが少なくとも 0.24.0 以上の場合にのみ関連します。
  * `payload`: `notify_cb` と `progress_cb` に渡すペイロード。
  * `context_lines`: ハンクの端を定義するために使用される *変更されていない* 行の数。これは、コンテキストを提供するためにハンクの前後に表示される行の数でもあります。デフォルトは 3 です。
  * `interhunk_lines`: 2 つの別々のハンクの間に許可される *変更されていない* 行の最大数。デフォルトは 0 です。
  * `id_abbrev`: 出力する省略された [`GitHash`](@ref) の長さを設定します。デフォルトは `7` です。
  * `max_size`: blob の最大ファイルサイズ。このサイズを超えると、バイナリ blob として扱われます。デフォルトは 512 MB です。
  * `old_prefix`: diff の片側に古いファイルを配置するための仮想ファイルディレクトリ。デフォルトは `"a"` です。
  * `new_prefix`: diff の片側に新しいファイルを配置するための仮想ファイルディレクトリ。デフォルトは `"b"` です。
