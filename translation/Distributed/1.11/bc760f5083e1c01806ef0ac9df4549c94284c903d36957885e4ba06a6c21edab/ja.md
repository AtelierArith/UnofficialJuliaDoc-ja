```julia
default_addprocs_params(mgr::ClusterManager) -> Dict{Symbol, Any}
```

クラスターマネージャーによって実装されています。`addprocs(mgr)` の呼び出し時に渡されるデフォルトのキーワード引数です。最小限のオプションセットは、`default_addprocs_params()` を呼び出すことで利用できます。
