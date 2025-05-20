```
channel_from_id(id) -> c
```

A low-level API which returns the backing `AbstractChannel` for an `id` returned by [`remoteref_id`](@ref). The call is valid only on the node where the backing channel exists.
