```julia
add!(repo::GitRepo, files::AbstractString...; flags::Cuint = Consts.INDEX_ADD_DEFAULT)
add!(idx::GitIndex, files::AbstractString...; flags::Cuint = Consts.INDEX_ADD_DEFAULT)
```

`files`で指定されたパスのすべてのファイルをインデックス`idx`（または`repo`のインデックス）に追加します。ファイルがすでに存在する場合、インデックスエントリは更新されます。ファイルがまだ存在しない場合、新たにインデックスに追加されます。`files`にはグロブパターンが含まれる場合があり、これが展開され、一致するファイルが追加されます（`INDEX_ADD_DISABLE_PATHSPEC_MATCH`が設定されていない限り、以下を参照）。ファイルが無視されている場合（`.gitignore`または設定内）、それは*追加されません*が、インデックスで既に追跡されている場合は*更新されます*。キーワード引数`flags`は、無視されたファイルに関する動作を制御するビットフラグのセットです：

  * `Consts.INDEX_ADD_DEFAULT` - 上記のデフォルト。
  * `Consts.INDEX_ADD_FORCE` - 既存の無視ルールを無視し、すでに無視されている場合でもファイルをインデックスに強制的に追加します。
  * `Consts.INDEX_ADD_CHECK_PATHSPEC` - `INDEX_ADD_FORCE`と同時に使用することはできません。ディスク上に存在する`files`内の各ファイルが無視リストに含まれていないことを確認します。ファイルの1つが*無視されている*場合、関数は`EINVALIDSPEC`を返します。
  * `Consts.INDEX_ADD_DISABLE_PATHSPEC_MATCH` - グロブマッチングをオフにし、`files`で指定されたパスと正確に一致するファイルのみをインデックスに追加します。
