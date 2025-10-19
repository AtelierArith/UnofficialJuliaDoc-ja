```julia
Base.compilecache(module::PkgId)
```

モジュールとそのすべての依存関係のためのプリコンパイルキャッシュファイルを作成します。これはパッケージのロード時間を短縮するために使用できます。キャッシュファイルは `DEPOT_PATH[1]/compiled` に保存されます。重要な注意事項については [Module initialization and precompilation](@ref) を参照してください。
