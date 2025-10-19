```julia
send(ws::WebSocket, msg)
```

Send a message on a websocket connection. If `msg` is an `AbstractString`, a TEXT websocket message will be sent; if `msg` is an `AbstractVector{UInt8}`, a BINARY websocket message will be sent. Otherwise, `msg` should be an iterable of either `AbstractString` or `AbstractVector{UInt8}`, and a fragmented message will be sent, one frame for each iterated element.

Control frames can be sent by calling `ping(ws[, data])`, `pong(ws[, data])`, or `close(ws[, body::WebSockets.CloseFrameBody])`. Calling `close` will initiate the close sequence and close the underlying connection.
