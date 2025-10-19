```julia
flush(c::Connection)
```

Flush a TCP buffer by toggling the Nagle algorithm off and on again for a socket. This forces the socket to send whatever data is within its buffer immediately, rather than waiting 10's of milliseconds for the buffer to fill more.
