```julia
LibGit2.DiffDelta
```

エントリへの変更の説明。[`git_diff_delta`](https://libgit2.org/libgit2/#HEAD/type/git_diff_delta) 構造体に一致します。

フィールドは次のことを示します：

  * `status`: `Consts.DELTA_STATUS` のいずれかで、ファイルが追加/変更/削除されたかどうかを示します。
  * `flags`: デルタおよび各側のオブジェクトのフラグ。ファイルをバイナリ/テキストとして扱うか、差分の各側に存在するか、オブジェクトIDが正しいことが知られているかどうかを決定します。
  * `similarity`: ファイルが名前変更またはコピーされたかどうかを示すために使用されます。
  * `nfiles`: デルタ内のファイルの数（たとえば、デルタがサブモジュールのコミットIDで実行された場合、複数のファイルが含まれることがあります）。
  * `old_file`: 変更前のファイルに関する情報を含む [`DiffFile`](@ref)。
  * `new_file`: 変更後のファイルに関する情報を含む [`DiffFile`](@ref)。
