```julia
LibGit2.DiffOptionsStruct
```

[`git_diff_options`](https://libgit2.org/libgit2/#HEAD/type/git_diff_options) 構造体に一致します。

各フィールドの意味は次のとおりです。

  * `version`: 後で変更される場合に備えて指定する、使用中の構造体のバージョン。現時点では、常に `1` です。
  * `flags`: diff に表示するファイルを制御するフラグ。デフォルトは `DIFF_NORMAL` です。
  * `ignore_submodules`: サブモジュール内のファイルを調べるかどうか。デフォルトは `SUBMODULE_IGNORE_UNSPECIFIED` です。この場合、サブモジュールの設定によって diff に表示するかどうかが決まります。
  * `pathspec`: diff に含めるファイルのパス。デフォルトでは、リポジトリ内のすべてのファイルが対象になります。
  * `notify_cb`: ファイル差分が追加されるたびに、diff の変更をユーザーに通知する任意のコールバック。
  * `progress_cb`: diff の進行状況を表示する任意のコールバック。libgit2 のバージョンが 0.24.0 以降の場合にのみ有効です。
  * `payload`: `notify_cb` および `progress_cb` に渡すペイロード。
  * `context_lines`: ハンクの境界を定義するために使用する、*変更されていない*行数。ハンクの前後にコンテキストとして表示される行数もこれと同じです。デフォルトは 3 です。
  * `interhunk_lines`: 別々のハンク間に許容される、*変更されていない*行の最大数。この数を超えると、ハンクは結合されます。デフォルトは 0 です。
  * `id_abbrev`: 表示する [`GitHash`](@ref) の省略形の長さを設定します。デフォルトは `7` です。
  * `max_size`: blob の最大ファイルサイズ。このサイズを超えると、バイナリ blob として扱われます。デフォルトは 512 MB です。
  * `old_prefix`: diff の片側で古いファイルを配置する仮想ファイルディレクトリ。デフォルトは `"a"` です。
  * `new_prefix`: diff の片側で新しいファイルを配置する仮想ファイルディレクトリ。デフォルトは `"b"` です。
