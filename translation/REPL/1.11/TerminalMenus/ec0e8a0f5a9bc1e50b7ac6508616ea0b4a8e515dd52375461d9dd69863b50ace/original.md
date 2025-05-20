```
keypress(m::AbstractMenu, i::UInt32) -> Bool
```

Handle any non-standard keypress event. If `true` is returned, [`TerminalMenus.request`](@ref) will exit. Defaults to `false`.
