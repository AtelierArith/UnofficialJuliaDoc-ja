```julia
lbt_find_backing_library(symbol_name, interface; config::LBTConfig = lbt_get_config())
```

libblastrampoline からエクスポートされた指定のシンボルを実装するライブラリを表す `LBTLibraryInfo` を返します。これにより、Julia コードからの特定の BLAS 呼び出しをどのライブラリが処理するかを確認できます。次のいずれかに該当する場合、このメソッドは `nothing` を返します。

  * 読み込み済みのライブラリに目的のシンボルをエクスポートしているものがない（デフォルト関数が呼び出されます）。
  * シンボルが `lbt_set_forward()` によって設定されている。この場合、ライブラリの由来は追跡されません。

指定された `symbol_name` がエクスポート済みシンボルの一覧に含まれていない場合、`ArgumentError` がスローされます。
