```julia
LibuvStream
```

libuv が扱う IO ストリームの抽象型です。

`stream isa LibuvStream` の場合、次のインターフェースに従う必要があります。

  * `stream.handle` が存在する場合は、`Ptr{Cvoid}` でなければなりません。
  * `stream.status` が存在する場合は、`Int` でなければなりません。
  * `stream.buffer` が存在する場合は、`IOBuffer` でなければなりません。
  * `stream.sendbuf` が存在する場合は、`Union{Nothing,IOBuffer}` でなければなりません。
  * `stream.cond` が存在する場合は、`GenericCondition` でなければなりません。
  * `stream.lock` が存在する場合は、`AbstractLock` でなければなりません。
  * `stream.throttle` が存在する場合は、`Int` でなければなりません。
