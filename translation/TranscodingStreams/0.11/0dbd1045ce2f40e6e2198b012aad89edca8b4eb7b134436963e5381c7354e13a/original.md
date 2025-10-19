```julia
position(stream::NoopStream)
```

Get the current poition of `stream`.

Note that this method may return a wrong position when

  * some data have been inserted by `TranscodingStreams.unread`, or
  * the position of the wrapped stream has been changed outside of this package.
