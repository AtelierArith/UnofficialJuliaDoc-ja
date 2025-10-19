```julia
skip(stream::TranscodingStream, offset)
```

Read bytes from `stream` until `offset` bytes have been read or `eof(stream)` is reached.

Return `stream`, discarding read bytes.

This function will not throw an `EOFError` if `eof(stream)` is reached before `offset` bytes can be read.
