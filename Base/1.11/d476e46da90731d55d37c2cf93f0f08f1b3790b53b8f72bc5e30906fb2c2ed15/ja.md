```
Base.runtests(tests=["all"]; ncores=ceil(Int, Sys.CPU_THREADS / 2),
              exit_on_error=false, revise=false, [seed])
```

`tests`にリストされたJuliaユニットテストを、`ncores`プロセッサを使用して実行します。`tests`は文字列または文字列の配列のいずれかです。`exit_on_error`が`false`の場合、1つのテストが失敗しても、他のファイルの残りのテストは実行されます。それ以外の場合、`exit_on_error == true`のときは破棄されます。`revise`が`true`の場合、テストを実行する前に`Base`または標準ライブラリへの変更を読み込むために`Revise`パッケージが使用されます。キーワード引数を介してシードが提供されると、それはテストが実行されるコンテキストでグローバルRNGのシードとして使用されます。そうでない場合、シードはランダムに選択されます。
