```julia
LibuvServer
```

libuv が処理する IOServer の抽象型です。

`server isa LibuvServer` の場合、次のインターフェースに従う必要があります。

  * `server.handle` は `Ptr{Cvoid}` でなければなりません。
  * `server.status` は `Int` でなければなりません。
  * `server.cond` は `GenericCondition` でなければなりません。
