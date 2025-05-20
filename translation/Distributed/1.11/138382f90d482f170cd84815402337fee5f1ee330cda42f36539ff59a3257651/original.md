```
client_refs
```

Tracks whether a particular `AbstractRemoteRef` (identified by its RRID) exists on this worker.

The `client_refs` lock is also used to synchronize access to `.refs` and associated `clientset` state.
