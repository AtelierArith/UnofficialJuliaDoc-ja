```julia
LibuvStream
```

An abstract type for IO streams handled by libuv.

If `stream isa LibuvStream`, it must obey the following interface:

  * `stream.handle`, if present, must be a `Ptr{Cvoid}`
  * `stream.status`, if present, must be an `Int`
  * `stream.buffer`, if present, must be an `IOBuffer`
  * `stream.sendbuf`, if present, must be a `Union{Nothing,IOBuffer}`
  * `stream.cond`, if present, must be a `GenericCondition`
  * `stream.lock`, if present, must be an `AbstractLock`
  * `stream.throttle`, if present, must be an `Int`
