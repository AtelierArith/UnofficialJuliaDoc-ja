```julia
Future(w::Int, rrid::RRID, v::Union{Some, Nothing}=nothing)
```

`Future`は、終了ステータスと時間が不明な単一の計算のプレースホルダーです。複数の潜在的な計算については、`RemoteChannel`を参照してください。`AbstractRemoteRef`を識別するには`remoteref_id`を参照してください。
