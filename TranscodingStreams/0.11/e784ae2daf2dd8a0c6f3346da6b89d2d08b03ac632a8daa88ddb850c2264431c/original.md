```
position(stream::TranscodingStream)
```

Return the number of bytes read from or written to `stream`.

Note that the returned value will be different from that of the underlying stream wrapped by `stream`.  This is because `stream` buffers some data and the codec may change the length of data.
