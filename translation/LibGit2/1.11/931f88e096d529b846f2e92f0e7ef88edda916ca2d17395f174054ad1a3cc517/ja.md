```julia
add!(repo::GitRepo, files::AbstractString...; flags::Cuint = Consts.INDEX_ADD_DEFAULT)
add!(idx::GitIndex, files::AbstractString...; flags::Cuint = Consts.INDEX_ADD_DEFAULT)
```

`files`で指定されたパスのすべてのファイルを、`idx`（または`repo`のインデックス）に追加します。ファイルがすでに存在する場合は、インデックスのエントリが更新されます。まだ存在しない場合は、新たにインデックスに追加されます。`files`にはグロブパターンを指定できます。その場合、パターンが展開され、一致するファイルが追加されます（ただし、`INDEX_ADD_DISABLE_PATHSPEC_MATCH`が設定されている場合を除きます。下記参照）。ファイルが`.gitignore`または設定ファイルで無視対象になっている場合、インデックスで追跡済みでない限り追加されません。追跡済みであれば更新されます。キーワード引数`flags`は、無視対象ファイルの扱いを制御するビットフラグの集合です。

  * `Consts.INDEX_ADD_DEFAULT` - デフォルト。上記のとおりです。
  * `Consts.INDEX_ADD_FORCE` - 既存の無視ルールを無視し、すでに無視対象となっているファイルも強制的にインデックスに追加します。
  * `Consts.INDEX_ADD_CHECK_PATHSPEC` - `INDEX_ADD_FORCE`と同時には使用できません。`files`に含まれるファイルのうち、ディスク上に存在するものが無視リストに含まれていないことを確認します。ファイルが無視対象の場合、関数は`EINVALIDSPEC`を返します。
  * `Consts.INDEX_ADD_DISABLE_PATHSPEC_MATCH` - グロブによる照合を無効にし、`files`で指定されたパスと完全に一致するファイルのみをインデックスに追加します。
