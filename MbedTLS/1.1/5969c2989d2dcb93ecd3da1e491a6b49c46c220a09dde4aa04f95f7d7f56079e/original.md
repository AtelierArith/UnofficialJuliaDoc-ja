```
readbytes!(ctx::SSLContext, buf::Vector{UInt8}, nbytes=length(buf); kw...)
```

Copy at most `nbytes` of decrypted data from `ctx` into `buf`. If `all=true`: wait for sufficient decrypted data to be available. Less than `nbytes` may be copied if the peer sends TLS `close_notify` or closes the connection. Returns number of bytes copied into `buf` (`<= nbytes`).
