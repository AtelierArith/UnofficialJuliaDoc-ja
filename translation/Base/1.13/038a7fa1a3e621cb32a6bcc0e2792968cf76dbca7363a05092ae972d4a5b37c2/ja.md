```julia
Base.compilecache(module::PkgId)
```

モジュールとそのすべての依存関係を含む、プリコンパイル済みキャッシュファイルを作成します。これにより、パッケージの読み込み時間を短縮できます。キャッシュファイルは`DEPOT_PATH[1]/compiled`に保存されます。重要な注意事項については、[Module initialization and precompilation](@ref)を参照してください。
