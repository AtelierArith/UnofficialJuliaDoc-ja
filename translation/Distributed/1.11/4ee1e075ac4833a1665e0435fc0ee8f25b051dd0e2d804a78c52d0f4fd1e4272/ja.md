```julia
default_addprocs_params(mgr::ClusterManager) -> Dict{Symbol, Any}
```

クラスターマネージャによって実装されます。`addprocs(mgr)`を呼び出すときに渡されるデフォルトのキーワードパラメータ。最小限のオプションセットは`default_addprocs_params()`を呼び出すことで利用可能です。
