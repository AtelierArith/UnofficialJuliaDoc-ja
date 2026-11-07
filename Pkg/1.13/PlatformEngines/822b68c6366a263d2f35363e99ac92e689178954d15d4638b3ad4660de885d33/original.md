```julia
with_download_cancellation(f, cancellation::DownloadCancellation)
```

Run `f`, registering every download started within it, including the ones started on tasks spawned by `f`, with `cancellation`.
