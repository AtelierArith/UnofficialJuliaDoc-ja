```julia
Base.runtests(tests=["all"]; ncores=ceil(Int, Sys.CPU_THREADS / 2),
              exit_on_error=false, revise=false, propagate_project=true, [seed], [julia_args::Cmd])
```

`tests`にリストされたJuliaユニットテストを、`ncores`プロセッサを使用して実行します。`tests`は文字列または文字列の配列のいずれかです。`exit_on_error`が`false`の場合、1つのテストが失敗しても、他のファイルの残りのテストは引き続き実行されます。`exit_on_error == true`の場合は、それ以外のテストは破棄されます。`revise`が`true`の場合、テストを実行する前に`Base`や標準ライブラリへの変更を読み込むために`Revise`パッケージが使用されます。`propagate_project`が`true`の場合、現在のプロジェクトがテスト環境に伝播されます。キーワード引数を介してシードが提供されると、それはテストが実行されるコンテキストでグローバルRNGのシードとして使用されます。そうでない場合、シードはランダムに選ばれます。引数`julia_args`は、テストプロセスにカスタム`julia`コマンドラインフラグを渡すために使用できます。
