```julia
LibGit2.DiffFile
```

差分の片側を表します。[`git_diff_file`](https://libgit2.org/libgit2/#HEAD/type/git_diff_file) 構造体に対応します。

各フィールドの意味は次のとおりです。

  * `id`: 差分内の項目の [`GitHash`](@ref)。差分のこの側で項目が空の場合（たとえば、ファイルの削除を表す差分の場合）、値は `GitHash(0)` になります。
  * `path`: リポジトリの作業ディレクトリを基準とした、項目への `NULL` 終端のパス。
  * `size`: 項目のサイズ（バイト単位）。
  * `flags`: [`git_diff_flag_t`](https://libgit2.org/libgit2/#HEAD/type/git_diff_flag_t) フラグの組み合わせ。この整数の `i` ビット目によって、`i` フラグ目が設定されます。
  * `mode`: 項目の [`stat`](@ref) モード。
  * `id_abbrev`: `0.25.0` 以降の LibGit2 バージョンでのみ存在します。[`string`](@ref) を使って変換した場合の `id` フィールドの長さです。通常は `OID_HEXSZ`（40）と同じです。
