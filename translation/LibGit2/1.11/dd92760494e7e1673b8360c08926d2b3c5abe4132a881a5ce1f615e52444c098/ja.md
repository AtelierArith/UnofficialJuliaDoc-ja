```julia
LibGit2.DiffFile
```

デルタの片側の説明です。[`git_diff_file`](https://libgit2.org/libgit2/#HEAD/type/git_diff_file) 構造体に対応します。

各フィールドの意味は次のとおりです。

  * `id`: diff 内の項目の [`GitHash`](@ref) です。diff のこの側で項目が空の場合（たとえば、ファイルの削除を表す diff の場合）、値は `GitHash(0)` になります。
  * `path`: リポジトリの作業ディレクトリを基準とした、項目への `NULL` 終端のパスです。
  * `size`: 項目のサイズ（バイト単位）です。
  * `flags`: [`git_diff_flag_t`](https://libgit2.org/libgit2/#HEAD/type/git_diff_flag_t) フラグを組み合わせた値です。この整数の `i` ビット目が、`i` フラグ目を設定します。
  * `mode`: 項目の [`stat`](@ref) モードです。
  * `id_abbrev`: LibGit2 のバージョンが `0.25.0` 以上の場合にのみ存在します。[`string`](@ref) を使って変換したときの `id` フィールドの長さです。通常は `OID_HEXSZ`（40）と同じです。
