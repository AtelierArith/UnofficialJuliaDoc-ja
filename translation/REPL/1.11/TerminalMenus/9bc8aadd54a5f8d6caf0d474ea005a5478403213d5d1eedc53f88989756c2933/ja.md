```julia
keypress(m::AbstractMenu, i::UInt32)::Bool
```

標準以外のキー押下イベントを処理します。`true` が返された場合、[`TerminalMenus.request`](@ref) は終了します。デフォルトは `false` です。
