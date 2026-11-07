```julia
add!(repo::GitRepo, files::AbstractString...; flags::Cuint = Consts.INDEX_ADD_DEFAULT)
add!(idx::GitIndex, files::AbstractString...; flags::Cuint = Consts.INDEX_ADD_DEFAULT)
```

`files`で指定されたパスのファイルをすべて、`idx`（または`repo`のインデックス）に追加します。ファイルがすでに存在する場合は、インデックスのエントリが更新されます。まだ存在しない場合は、新たにインデックスに追加されます。`files`には、展開されるグロブパターンを指定できます。一致するファイルはすべて追加されます（ただし、`INDEX_ADD_DISABLE_PATHSPEC_MATCH`が設定されている場合を除きます。下記参照）。ファイルが（`.gitignore`または設定ファイルで）無視対象になっている場合、インデックスですでに追跡されているファイルを更新する場合を除き、追加されません。キーワード引数`flags`は、無視対象ファイルの扱いを制御するビットフラグの集合です。

  * `Consts.INDEX_ADD_DEFAULT` - デフォルト。上記のとおりです。
  * `Consts.INDEX_ADD_FORCE` - 既存の無視ルールを無視し、すでに無視対象になっているファイルも強制的にインデックスに追加します。
  * `Consts.INDEX_ADD_CHECK_PATHSPEC` - `INDEX_ADD_FORCE`と同時には使用できません。`files`内でディスク上に存在する各ファイルが、無視リストに含まれていないことを確認します。ファイルが無視対象の場合、この関数は`EINVALIDSPEC`を返します。
  * `Consts.INDEX_ADD_DISABLE_PATHSPEC_MATCH` - グロブによる照合を無効にし、`files`で指定されたパスと完全に一致するファイルのみをインデックスに追加します。
