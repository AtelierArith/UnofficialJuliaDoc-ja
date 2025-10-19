```julia
close(ws, body::WebSockets.CloseFrameBody=nothing)
```

Initiate a close sequence on a websocket connection. `body` is an optional `WebSockets.CloseFrameBody` with a status code and optional reason message. If a CLOSE frame has already been received, then a responding CLOSE frame is sent and the connection is closed. If a CLOSE frame hasn't already been received, the CLOSE frame is sent and `receive` is attempted to receive the responding CLOSE frame.
