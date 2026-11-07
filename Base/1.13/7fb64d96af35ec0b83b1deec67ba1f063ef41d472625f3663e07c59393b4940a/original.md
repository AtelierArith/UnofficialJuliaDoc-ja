```julia
LibuvServer
```

An abstract type for IOServers handled by libuv.

If `server isa LibuvServer`, it must obey the following interface:

  * `server.handle` must be a `Ptr{Cvoid}`
  * `server.status` must be an `Int`
  * `server.cond` must be a `GenericCondition`
