```
fetch(c::RemoteChannel)
```

[`RemoteChannel`](@ref) から値を待って取得します。発生する例外は [`Future`](@ref) と同じです。取得したアイテムは削除されません。
