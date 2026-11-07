```julia
Base.runtests(tests=["all"]; ncores=ceil(Int, Sys.EFFECTIVE_CPU_THREADS / 2),
              exit_on_error=false, revise=false, propagate_project=true, [seed], [julia_args::Cmd])
```

`tests`（文字列または文字列の配列）で指定された Julia のユニットテストを、`ncores` プロセッサを使用して実行します。`exit_on_error` が `false` の場合、あるテストが失敗しても、ほかのファイルにある残りのテストはすべて実行されます。それ以外の場合は、`exit_on_error == true` の時点で残りのテストは実行されません。`revise` が `true` の場合、テストの実行前に `Revise` パッケージを使って、`Base` または標準ライブラリへの変更を読み込みます。`propagate_project` が true の場合、現在のプロジェクトがテスト環境に引き継がれます。キーワード引数でシードが指定されていれば、テストの実行環境でグローバル RNG のシードとして使用されます。指定されていない場合は、シードがランダムに選ばれます。引数 `julia_args` を使うと、テストプロセスにカスタムの `julia` コマンドラインフラグを渡せます。
