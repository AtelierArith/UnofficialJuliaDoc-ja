```julia
Future(w::Int, rrid::RRID, v::Union{Some, Nothing}=nothing)
```

`Future` は、終了するかどうかや終了までの時間が不明な単一の計算を表すプレースホルダーです。複数の計算候補については、`RemoteChannel` を参照してください。`AbstractRemoteRef` の識別方法については、`remoteref_id` を参照してください。
