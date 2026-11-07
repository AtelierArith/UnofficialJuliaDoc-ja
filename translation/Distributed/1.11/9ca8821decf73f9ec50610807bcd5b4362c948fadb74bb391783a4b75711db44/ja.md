```julia
fetch(c::RemoteChannel)
```

[`RemoteChannel`](@ref)から値が得られるまで待機し、その値を取得します。発生する例外は[`Future`](@ref)の場合と同じです。取得した項目は削除されません。
