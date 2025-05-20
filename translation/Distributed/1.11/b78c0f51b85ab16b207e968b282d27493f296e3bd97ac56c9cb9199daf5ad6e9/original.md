```
remoteref_id(r::AbstractRemoteRef) -> RRID
```

`Future`s and `RemoteChannel`s are identified by fields:

  * `where` - refers to the node where the underlying object/storage referred to by the reference actually exists.
  * `whence` - refers to the node the remote reference was created from. Note that this is different from the node where the underlying object referred to actually exists. For example calling `RemoteChannel(2)` from the master process would result in a `where` value of 2 and a `whence` value of 1.
  * `id` is unique across all references created from the worker specified by `whence`.

Taken together,  `whence` and `id` uniquely identify a reference across all workers.

`remoteref_id` is a low-level API which returns a `RRID` object that wraps `whence` and `id` values of a remote reference.
