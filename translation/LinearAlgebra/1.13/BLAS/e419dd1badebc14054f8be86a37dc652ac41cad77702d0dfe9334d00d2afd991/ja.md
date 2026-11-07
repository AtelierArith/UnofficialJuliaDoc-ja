```julia
lbt_find_backing_library(symbol_name, interface; config::LBTConfig = lbt_get_config())
```

libblastrampoline からエクスポートされた指定シンボルを実装するライブラリを表す `LBTLibraryInfo` を返します。これにより、Julia コードから呼び出される特定の BLAS 関数を、どのライブラリが処理するかを確認できます。次のいずれかに該当する場合、このメソッドは `nothing` を返します。

  * 読み込まれているライブラリのいずれも目的のシンボルをエクスポートしていない（デフォルト関数が呼び出されます）
  * シンボルが `lbt_set_forward()` によって設定されている（この場合、ライブラリの由来は追跡されません）

指定された `symbol_name` がエクスポート済みシンボルの一覧に含まれていない場合、`ArgumentError` がスローされます。
