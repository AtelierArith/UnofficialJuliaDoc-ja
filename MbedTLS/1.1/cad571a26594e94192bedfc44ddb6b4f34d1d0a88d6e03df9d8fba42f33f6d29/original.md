```julia
unsafe_read(ctx::SSLContext, buf::Ptr{UInt8}, nbytes::UInt)
```

Copy `nbytes` of decrypted data from `ctx` into `buf`. Wait for sufficient decrypted data to be available. Throw `EOFError` if the peer sends TLS `close_notify` or closes the connection before `nbytes` have been copied.
