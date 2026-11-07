```julia
DownloadCancellation()
```

Tracks the downloads that are currently in flight inside a [`with_download_cancellation`](@ref) scope so that they can all be aborted at once.
