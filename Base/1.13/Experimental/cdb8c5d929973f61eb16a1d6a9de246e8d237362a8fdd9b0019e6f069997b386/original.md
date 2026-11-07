```julia
Base.Experimental.disable_new_worlds()
```

Mark that no new worlds (methods additions, deletions, etc) are permitted to be created at any future time, allowing for lower latencies for some operations and slightly lower memory usage, by eliminating the tracking of those possible invalidation.
