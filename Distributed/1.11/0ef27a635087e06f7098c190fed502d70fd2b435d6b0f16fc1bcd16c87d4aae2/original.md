```
default_addprocs_params(mgr::ClusterManager) -> Dict{Symbol, Any}
```

Implemented by cluster managers. The default keyword parameters passed when calling `addprocs(mgr)`. The minimal set of options is available by calling `default_addprocs_params()`
