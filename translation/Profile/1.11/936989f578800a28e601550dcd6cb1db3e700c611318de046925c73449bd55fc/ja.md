```julia
clear_malloc_data()
```

julia を `--track-allocation` 付きで実行すると、保存されているメモリ割り当てデータがすべて消去されます。テストしたいコマンドを実行して（JIT コンパイルを強制するため）、その後 [`clear_malloc_data`](@ref) を呼び出します。次に、コマンドをもう一度実行してから Julia を終了し、生成された `*.mem` ファイルを確認します。
