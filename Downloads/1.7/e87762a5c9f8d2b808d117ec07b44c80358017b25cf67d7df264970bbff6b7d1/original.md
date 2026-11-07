```julia
Downloader(; [ grace::Real = 30 ])
```

`Downloader` objects are used to perform individual `download` operations. Connections, name lookups and other resources are shared within a `Downloader`. These connections and resources are cleaned up after a configurable grace period (default: 30 seconds) since anything was downloaded with it, or when it is garbage collected, whichever comes first. If the grace period is set to zero, all resources will be cleaned up immediately as soon as there are no more ongoing downloads in progress. If the grace period is set to `Inf` then resources are not cleaned up until `Downloader` is garbage collected.
