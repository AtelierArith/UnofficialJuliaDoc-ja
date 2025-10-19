```julia
iterate(ws)
```

Continuously call `receive(ws)` on a `WebSocket` connection, with each iteration yielding a message until the connection is closed. E.g.

```julia
for msg in ws
    # do something with msg
end
```
