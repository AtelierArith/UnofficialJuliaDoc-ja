```julia
iswritable(ctx::SSLContext)
```

True unless:

  * `close(::SSLContext)` is called, or
  * `closewrite(::SSLContext)` is called, or
  * the peer closed the connection.
