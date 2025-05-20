```
LibGit2.DiffFile
```

デルタの片側の説明。[`git_diff_file`](https://libgit2.org/libgit2/#HEAD/type/git_diff_file) 構造体に一致します。

フィールドは次のことを表します：

  * `id`: 差分内のアイテムの [`GitHash`](@ref)。この差分のこの側でアイテムが空である場合（たとえば、ファイルの削除の差分の場合）、これは `GitHash(0)` になります。
  * `path`: リポジトリの作業ディレクトリに対するアイテムの `NULL` 終端パス。
  * `size`: アイテムのサイズ（バイト単位）。
  * `flags`: [`git_diff_flag_t`](https://libgit2.org/libgit2/#HEAD/type/git_diff_flag_t) フラグの組み合わせ。この整数の `i` 番目のビットが `i` 番目のフラグを設定します。
  * `mode`: アイテムの [`stat`](@ref) モード。
  * `id_abbrev`: LibGit2 バージョン `0.25.0` 以上でのみ存在します。[`string`](@ref) を使用して変換したときの `id` フィールドの長さ。通常は `OID_HEXSZ` (40) に等しいです。
