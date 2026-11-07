```julia
cancel_downloads(cancellation::DownloadCancellation)
```

Abort the downloads that are still in flight in `cancellation`'s scope, and make any download started in it from now on fail immediately rather than begin transferring.
