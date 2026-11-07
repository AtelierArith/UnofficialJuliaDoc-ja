```julia
clear_malloc_data()
```

`--track-allocation` を指定して julia を実行すると、保存されているメモリ割り当てデータがすべて消去されます。テストしたいコマンドを実行して（JIT コンパイルを強制したうえで）、[`clear_malloc_data`](@ref) を呼び出します。その後、コマンドをもう一度実行してから Julia を終了し、生成された `*.mem` ファイルを確認します。
