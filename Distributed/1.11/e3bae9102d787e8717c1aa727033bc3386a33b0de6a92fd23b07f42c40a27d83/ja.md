```
Future(w::Int, rrid::RRID, v::Union{Some, Nothing}=nothing)
```

`Future`は、未知の終了状態と時間の単一計算のプレースホルダーです。複数の潜在的な計算については、`RemoteChannel`を参照してください。`AbstractRemoteRef`を識別するには`remoteref_id`を参照してください。
