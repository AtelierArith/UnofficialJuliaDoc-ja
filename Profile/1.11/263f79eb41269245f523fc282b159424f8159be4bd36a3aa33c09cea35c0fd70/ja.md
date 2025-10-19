```julia
clear_malloc_data()
```

`--track-allocation`オプションを使用してjuliaを実行しているときに、保存されたメモリ割り当てデータをクリアします。テストしたいコマンドを実行して（JITコンパイルを強制するために）、次に[`clear_malloc_data`](@ref)を呼び出します。その後、再度コマンドを実行し、Juliaを終了し、結果の`*.mem`ファイルを調べます。
