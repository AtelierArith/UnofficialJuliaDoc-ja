```julia
fetch(c::RemoteChannel)
```

[`RemoteChannel`](@ref)から値が届くのを待ち、取得します。発生する例外は[`Future`](@ref)と同じです。取得した項目は削除されません。
