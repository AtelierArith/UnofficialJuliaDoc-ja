```julia
isreadable(ctx::SSLContext)
```

True unless:

  * TLS `close_notify` was received, or
  * the peer closed the connection (and the TLS buffer is empty), or
  * an un-handled exception occurred while reading.
