```julia
GC.gc([full=true])
```

Perform garbage collection. The argument `full` determines the kind of collection: a full collection (default) traverses all live objects (i.e. full mark) and should reclaim memory from all unreachable objects. An incremental collection only reclaims memory from young objects which are not reachable.

The GC may decide to perform a full collection even if an incremental collection was requested.

!!! warning
    Excessive use will likely lead to poor performance.

