```julia
Base.gc_live_bytes()
```

Return the total size (in bytes) of objects currently in memory. This is computed as the total size of live objects after the last garbage collection, plus the number of bytes allocated since then.
